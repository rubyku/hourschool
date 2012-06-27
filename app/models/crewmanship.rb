class Crewmanship < ActiveRecord::Base
  # status(trial_active,trial_expired,trial_canceled,active,past_due,canceled,completed)
  belongs_to :mission
  belongs_to :user

  def make_active_or_expire
    if user.stripe_customer
      user.update_attributes!(:billing_day_of_month => Time.now.day)
      if user.charge_for_active_crewmanships
        update_attributes(:status => 'active')
        true
      else
        #usermailer
        update_attributes(:status => 'past_due')
        false
      end
    else
      update_attributes(:status => 'trial_expired')
    end
  end

  def price
    if status == 'active'
      10.00
    else
      0
    end
  end

  def self.activate_or_expire_crewmanships
    Crewmanship.where(:status => 'trial_active').where(:trial_expires_at => Date.today).each do |crewmanship|
      crewmanship.make_active_or_expire
    end
  end

end
