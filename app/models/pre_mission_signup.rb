class PreMissionSignup < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :description
  validate :user_or_email

  private
  def user_or_email
    if user
      return true
    else
      if email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i  
        return true
      else
        self.errors[:email] << "is not formatted properly"
      end  
    end
  end
end
