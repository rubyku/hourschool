class City < ActiveRecord::Base
  has_many :courses, :dependent => :destroy
  has_many :csuggestions, :dependent => :destroy
  
  validates_presence_of :name, :state
  validate :city_supported
  #, :zip
  attr_accessible :name, :state, :zip
  
  
  
  private
  def city_supported
    errors.add(:name, "We are not in your city yet.") if !SUPPORTED_CITIES.include?(name)
  end
end
