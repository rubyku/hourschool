class Admin::CoursesController < Admin::AdminController
  layout 'application'

  def index

    @courses = current_account ? current_account.courses.order('DATE(date) DESC').where(:status => "live") : Course.order('DATE(date) DESC').where(:status => "live")

    @proposals = current_account ? current_account.courses.order('DATE(created_at) DESC').where(:status => "proposal") : Course.order('DATE(created_at) DESC').where(:status => "proposal")

    @approved = current_account ? current_account.courses.order('DATE(created_at) DESC').where(:status => "approved") : Course.order('DATE(created_at) DESC').where(:status => "approved")

    @user = current_user

  end

  def test
    @courses = current_account ? current_account.courses.order('DATE(date) DESC').where(:status => "live") : Course.order('DATE(date) DESC').where(:status => "live")
  end


  def show
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    @course.update_attribute :status, "approved"

    #send email and other stuff here to the teacher
    if @course.account.nil?
      current_account = nil
    else
      current_account = @course.account
    end
    UserMailer.send_course_approval_mail(@course.teacher.email, @course.teacher.name, @course, current_account).deliver
    redirect_to admin_courses_path
  end

end