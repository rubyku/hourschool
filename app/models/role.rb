class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :course_id, :presence => true
  validates :user_id,   :presence => true, :uniqueness => { :scope => :course_id }


end
