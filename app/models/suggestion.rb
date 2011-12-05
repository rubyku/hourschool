class Suggestion < ActiveRecord::Base
  belongs_to :city
  validates_presence_of :name, :requested_by

  attr_accessible :name, :description, :requested_by

  acts_as_voteable

  extend FriendlyId
  friendly_id :name, :use => :history

end
