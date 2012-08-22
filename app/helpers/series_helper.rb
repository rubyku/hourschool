module SeriesHelper
  def checked_for_series_if(series, day, end_date = 52.weeks.from_now)
    if series.schedule_hash.present?
      days_of_the_week = series.entries(end_date).map {|s| s.in_time_zone.strftime('%A').downcase.to_sym }
      days_of_the_week.include? day
    else
      false
    end
  end

  def first_day_for_series(series, end_date = 52.weeks.from_now, &block)
    day = series.schedule.occurrences(end_date).first
    if day.blank? && block.present?
      day = block.call
    end
    day
  end

  def first_day_or_weeks_since_last_course(series, end_date = 52.weeks.from_now)
    if course = series.last_course
      fallback_day = course.day_in_weeks_from_now(2.weeks)
    else
      fallback_day = 2.weeks.from_now
    end
    first_day_for_series(series, end_date) {fallback_day}
  end

  def number_of_occurrences_in_series_or(series, default, options = {})
    options[:end_date] ||= 52.weeks.from_now
    count = series.schedule.occurrences(options[:end_date]).try(:count)
    count == 0 ? default : count
  end

end
