class City < ActiveRecord::Base
  has_many :courses, :dependent => :destroy
  has_many :csuggestions, :dependent => :destroy

  validates_presence_of :name, :state

  attr_accessible :name, :state, :zip
  attr_accessible :lat, :lng

  #include Geokit::Mappable
  acts_as_mappable

  def name_state
    "#{name}, #{state}"
  end

end
