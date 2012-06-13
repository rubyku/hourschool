class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :mission
  
  has_and_belongs_to_many :courses
end
