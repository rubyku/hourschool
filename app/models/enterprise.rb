class Enterprise < ActiveRecord::Base
  has_many :members, :dependent => :destroy
  has_many :ecourses, :dependent => :destroy
  has_one :subdomain, :dependent => :destroy
  has_many :esuggestions, :dependent => :destroy
  validates_presence_of :name,:domain
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :domain,:area
end
