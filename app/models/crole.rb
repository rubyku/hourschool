class Crole < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  attr_accessible :role, :attending
end
