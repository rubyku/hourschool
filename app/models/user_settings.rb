class UserSettings < ActiveRecord::Base
  include UserSettings::Flags

  set_flag_column :preferences

  # Important: Methods specified as flags need to be coppied over to User.rb
  # as delegates
  # User Delegates these methods to UserSettings
  # @example
  #   u = User.rs
  #   u.e_social_join #=> false
  #   u.update_attributes(:e_social_join => true)
  #   u.e_social_join #=> true

  # email notifications

  flag :auto_follow_classmates,       1 <<  0 # auto follow class mates?
  flag :auto_follow_facebook,         1 <<  1 # auto follow class facebook friends ?
  flag :notify_classmate_new_course,  1 <<  2
  flag :notify_classmate_attend,      1 <<  3

  belongs_to :user

  validates_presence_of :user

  after_create :set_defaults

  def set_defaults
    self.update_attributes(
      :auto_follow_classmates      => true,
      :auto_follow_facebook        => true,
      :notify_classmate_new_course => true,
      :notify_classmate_attend     => true)
  end

  def update_settings(settings)
    valid_keys = self.class.flags.keys
    filtered_settings = settings.select {|k,v| valid_keys.include?(k.to_sym) }
    filtered_settings.each do |key, value|
      self.send(:"#{key}=", value)
    end
    self.save!
  end

  def get_settings( form_values=false )
    self.class.flags.keys.inject({}) do |hash, key|
      value = self.send(key)
      if form_values
        value = value ? '1' : '0'
      end
      hash[key] = value
      hash
    end
  end

  def put_settings(settings)
    reset_settings
    self.class.flags.inject({}) do |hash, key|
      hash[key] = self.send(key)
      hash
    end
  end



  private


  def reset_settings
    self.preferences=0
  end
end