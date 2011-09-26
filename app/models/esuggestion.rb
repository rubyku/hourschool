class Esuggestion < ActiveRecord::Base
  belongs_to :enterprise
  validates_presence_of :name, :description
  acts_as_voteable
end
