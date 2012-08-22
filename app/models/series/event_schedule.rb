module Series::EventSchedule
  extend ActiveSupport::Concern

  include IceCube

  DEFAULT_PUBLISH_DAYS_BEFORE = 14 # days
  SCHEDULE_OUT_TO             = 6 # months

  included do
    serialize   :schedule_hash, Hash
    after_save  :after_save_refresh_events!
  end


  def schedule=(new_schedule)
    hash = new_schedule.to_hash if new_schedule.is_a?(IceCube::Schedule)
    hash = new_schedule         if new_schedule.is_a?(Hash)
    hash ||= {}

    # If hash is not an IceCube::Schedule hash, it is our proprietary format, convert it
    hash = self.class.schedule_from_hash(hash).to_hash unless hash.has_key?(:rrules)


    raise 'not valid schedule'  unless hash.present?
    self.schedule_hash = hash
  end

  def schedule
    Schedule.from_hash(schedule_hash||{})
  end


  def clear_events_transaction!(&block)
    raise 'no block given' if block.blank?
    stale_events = schedule_events.where(:published => false).all
    return_val = block.call
    stale_events.map(&:destroy) if return_val.present?
  end


  def schedule_out_to
    SCHEDULE_OUT_TO.months.from_now.in_time_zone
  end

  def entries(end_time = 52.weeks.from_now)
    schedule.occurrences(end_time)
  end

  def build_events!
    raise 'no schedule' if schedule.blank?
    schedule.occurrences(schedule_out_to).each do |time|
      starts_at     = time.to_date
      publish_on    = starts_at - (publish_days_before||DEFAULT_PUBLISH_DAYS_BEFORE).days
      ScheduleEvent.create(:starts_at => starts_at, :publish_on => publish_on, :series => self, :published => false)
    end
    true
  end

  def refresh_events!
    clear_events_transaction! do
      build_events!
    end
  end

  private

  def after_save_refresh_events!
    return true unless schedule_hash_changed?
    refresh_events!
    true
  end

  public

  module ClassMethods
    include IceCube

    def start_end_from_hash(options)
      if options[:start_time].present?
        start_time = options[:start_time] if options[:start_time].is_a? DateTime
        start_time = DateTime.parse(options[:start_time]).in_time_zone if options[:start_time].is_a? String
        start_time = DateTime.new(options[:start_time]['(1i)'].to_i, options[:start_time]['(2i)'].to_i, options[:start_time]['(3i)'].to_i).in_time_zone if options[:start_time].is_a? Hash
      end
      end_time   = DateTime.parse(options[:end_time]  ).in_time_zone   if options[:end_time].present?
      start_time ||= 2.weeks.from_now.in_time_zone
      end_time   ||= (start_time + 1.year).in_time_zone
      return start_time, end_time
    end



    def schedule_from_hash(options = {})
      return Schedule.new() if options.blank?
      raise 'not a hash'    unless options.is_a? Hash
      start_time, end_time = start_end_from_hash(options)

      new_schedule = Schedule.new(start_time, :end_time => end_time)

      weekdays   = options[:weekdays]         || []
      count      = options[:count].try(:to_i) || 4

      rule = IceCube::Rule.weekly
      weekdays.each do |weekday|
        rule.day(weekday.to_sym)
      end

      rule.count(count)
      new_schedule.add_recurrence_rule(rule)

      new_schedule
    end
  end
end