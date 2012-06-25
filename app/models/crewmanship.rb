class Crewmanship < ActiveRecord::Base
  # status(trial_active,trial_expired,trial_canceled,active,canceled,completed)
  belongs_to :mission
  belongs_to :user

  after_create :set_expires_at

  def price
    full_price = 10.00
    if trial_expires_at == Date.today
      full_price
    else
      offset = [user.last_invoiced_at, trial_expires_at.to_time].max()
      prorate = canceled_at || Time.now
      days_since_last_invoice = ((prorate - offset) / 86400).round
      days_in_month = Time.days_in_month(Time.now.month, Time.now.year)
      # puts "offset: #{offset}"
      # puts "prorate: #{prorate}"
      # puts "#{full_price} / #{days_in_month} * #{days_since_last_invoice}"
      (full_price / days_in_month * days_since_last_invoice).round(2)
    end
  end

  private
  def set_expires_at
    update_attribute(:trial_expires_at, 30.days.from_now.to_date)
  end
end
