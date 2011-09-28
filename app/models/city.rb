class City < ActiveRecord::Base
  has_many :courses, :dependent => :destroy
  has_many :csuggestions, :dependent => :destroy
  
  validates_presence_of :name, :state
  
  attr_accessible :name, :state, :zip
  
  include Geokit::Mappable 
  
  
end
