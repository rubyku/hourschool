class Ecourse < ActiveRecord::Base
  belongs_to :enterprise
  has_many :members, :through => :eroles, :dependent => :destroy
  has_many :eroles, :dependent => :destroy
  
  attr_accessible :title,:description, :price, :seats, :date, :time, :place, :minimum
  validates_presence_of :title,:description, :price, :seats, :date, :time, :place, :minimum
  
  acts_as_taggable_on :categories
  
end
