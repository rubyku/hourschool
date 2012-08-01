class Crewmanship < ActiveRecord::Base
  # status(trial_active,trial_expired,trial_canceled,active,past_due,abandoned(past_due for a month),canceled,completed)
  belongs_to :mission
  belongs_to :user

  validates :user_id, :presence => true, :uniqueness => { :scope => :mission_id }

  def self.default_price
    10.00
  end

  def make_active_or_expire
    if user.stripe_customer #do we have their credit card details?
      user.update_attributes!(:billing_day_of_month => Time.now.day)
      if user.charge_for_active_crewmanships #if charge is successful 
        update_attributes(:status => 'active')
        true
      else
        #usermailer (ask user to enter payment info so we can charge)
        update_attributes(:status => 'past_due')
        false
      end
    else
      # UserMailer.subscription_expired()
      update_attributes(:status => 'trial_expired')
    end
  end

  def price
    result = {:amount => 0, :details => nil}
    if status == 'active' || status == 'past_due'
      if user.taught_class_between_last_billing_cycle?(mission)
        result[:details] = 'You taught a class in the last billing cycle.'
      elsif mission.courses.where('starts_at >= ?', user.last_months_billing_date.beginning_of_day).
            where('starts_at <= ?', user.this_months_billing_date.end_of_day).length == 0
        result[:details] = 'There were no events in the last billing cycle.'
      else
        result[:amount] = Crewmanship.default_price
      end
    end
    result
  end

  def self.activate_or_expire_crewmanships
    Crewmanship.where(:status => 'trial_active').where(:trial_expires_at => Date.today).each do |crewmanship|
      crewmanship.make_active_or_expire
    end
  end

end
