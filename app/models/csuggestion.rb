class Csuggestion < ActiveRecord::Base
  belongs_to :city
  validates_presence_of :name, :description
  acts_as_voteable
end
