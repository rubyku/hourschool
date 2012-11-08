class Admin::MetricsController < ApplicationController
  before_filter :authenticate_admin!

  def index

    # Overview
    @live_missions              = Mission.where(:account_id => nil).where(:status => "live")
    @draft_missions             = Mission.where(:account_id => nil).where(:status => "draft")

    @total_users                = User.all
    @total_fb_users             = User.where("fb_token is not null")

    @total_activated_users      = Role.select("DISTINCT(user_id)")

    @total_activated_students   = Role.where(:name => "student").select("DISTINCT(user_id)")
    @total_activated_teachers   = Role.where(:name => "teacher").select("DISTINCT(user_id)")

    # @total_repeat_users         = Role.group(:user_id).count.select {|user_id, count| count > 1}
    # @total_repeat_students      = Role.group(:user_id).where(:name => 'student').count.select {|user_id, count| count > 1}
    # @total_repeat_teachers      = Role.group(:user_id).where(:name => 'teacher').count.select {|user_id, count| count > 1}

    @total_courses              = Course.all
    @paying_courses             = Course.where('price != 0')
    @free_courses               = Course.where('price = 0')
    @draft_courses              = Course.where(:status => "draft")
    @courses_not_live           = Course.where("status = ? ", "approved").order('DATE(created_at) DESC')
    @happened_courses           = Course.where(:happening => true)

    # @total_transaction          = Payment.select('SUM(amount) as sum').first.sum.to_f

    #---------------------------------------------------------------------------------------------------------------

    # Goals of the month
    @users_this_month           = User.where("extract( month from DATE(created_at)) = 4").count
    @courses_this_month         = Course.where("extract( month from DATE(created_at)) = 4").count
    @transactions_this_month    = Payment.where("extract( month from DATE(created_at)) = 4").sum('amount')

    #---------------------------------------------------------------------------------------------------------------

    #Need Rally
    @courses_next7days          = Course.active.where("starts_at < ?", 7.days.from_now).order('DATE(starts_at) ASC').where(:status => "live")

    #Trends
    @users_by_month             = User.group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").count
    @courses_by_month           = Course.unscoped.group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").count

    @students_by_month          = Role.where(:name => 'student').group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").count
    @teachers_by_month          = Role.where(:name => 'teacher').group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").count
    @transaction_by_month       = Payment.group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").sum('amount')

    @top_accounts               = Account.where(:private => "false").find(:all, :include => :memberships).sort_by { |u| u.memberships.size }.reverse
    @top_missions               = Mission.where(:status => "live").find(:all, :include => :crewmanships).sort_by { |u| u.crewmanships.size }.reverse
    @top_users                  = User.where(:admin => false).find(:all, :include => :roles).sort_by { |u| u.roles.size }.reverse.first(20)

    #---------------------------------------------------------------------------------------------------------------

    #Impact
    @teachers                   = User.joins(:roles).where("roles.name = 'teacher'").uniq
    @students_and_teachers      = @teachers.where("role.names = 'student'").uniq
    @student_first
    @teacher_first
    @student_to_teacher         = User.joins(:roles).select("user_id").where("roles.name = 'teacher'").group("user_id").select("DISTINCT(role_id)")

  end

end
