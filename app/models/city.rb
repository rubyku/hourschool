class City < ActiveRecord::Base
  has_many :courses
  has_many :users 
  has_many :suggestions, :dependent => :destroy

  validates_presence_of :name, :state

  #include Geokit::Mappable
  acts_as_mappable

  def name_state
    "#{name}, #{state}"
  end
end
