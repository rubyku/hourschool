class Crewmanship < ActiveRecord::Base
  belongs_to :mission
  belongs_to :user

  after_create :set_expires_at

  private
  def set_expires_at
    update_attribute(:expires_at, 30.days.from_now)
  end
end
