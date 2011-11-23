class Notifications < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  attr_accessible :alert, :action
  
  
def pending_update 
  @user = current_user
  @approved_courses = @user.courses.where(:status => "approved")
  
  if @approved_courses.last.description.blank?
    "Please update your profile"
  end

end
