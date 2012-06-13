class Topic < ActiveRecord::Base
  belongs_to :user
  belongs_to :mission
  
  has_many :courses
end
