class Notifications < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  attr_accessible :alert, :action


end