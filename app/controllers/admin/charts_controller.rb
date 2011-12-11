class Admin::ChartsController < Admin::AdminController

  def index
    @users    = User.order('DATE(created_at) DESC').group("DATE(created_at)").count
    @courses  = Course.unscoped.order('DATE(created_at) DESC').group("DATE(created_at)").count
    @students = Role.where(:role => 'student').order('DATE(created_at) DESC').group("DATE(created_at)").count
    @teachers = Role.where(:role => 'student').order('DATE(created_at) DESC').group("DATE(created_at)").count
  end

end
