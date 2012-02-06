class Admin::ChartsController < Admin::AdminController

  def index
    
    # Goals of the month
    @users_this_month           = User.where("extract( month from DATE(created_at)) = 2").count
    @courses_this_month         = Course.where("extract( month from DATE(created_at)) = 2").count
    @transactions_this_month    = Payment.where("extract( month from DATE(created_at)) = 2").sum('amount')

    @users_last_month           = User.where("extract( month from DATE(created_at)) = 1").count
    @courses_last_month         = Course.where("extract( month from DATE(created_at)) = 1").count
    @transactions_last_month    = Payment.where("extract( month from DATE(created_at)) = 1").sum('amount')
    
    # For the next 7 days
    @courses_next7days          = Course.active.where("date < ?", 7.days.from_now).order('DATE(date) ASC')
    @courses_yesterday          = Course.where("date = ?", 1.day.ago) 
    
    @courses_not_live           = Course.where("status = ? ", "approved").order('DATE(created_at) DESC')
    
    # Sidebar
    
    @users    = User.order('DATE(created_at) DESC').group("DATE(created_at)").count
    @courses  = Course.unscoped.order('DATE(created_at) DESC').group("DATE(created_at)").count
    @students = Role.where(:name => 'student').order('DATE(created_at) DESC').group("DATE(created_at)").count
    @teachers = User.joins(:roles).where("roles.name = 'teacher'").order('DATE(roles.created_at) DESC')
    
    @total_users                = User.count
    @total_fb_users             = User.where("fb_token is not null").count
    @total_active_users         = Role.select("DISTINCT(user_id)").count
    @total_active_students      = Role.where(:name => 'student').select("DISTINCT(user_id)").count
    @total_active_teachers      = Role.where(:name => 'teacher').select("DISTINCT(user_id)").count
    @total_repeat_users         = Role.group(:user_id).count.select {|user_id, count| count > 1}.count    
    @total_repeat_students      = Role.group(:user_id).where(:name => 'student').count.select {|user_id, count| count > 1}.count
    @total_repeat_teachers      = Role.group(:user_id).where(:name => 'teacher').count.select {|user_id, count| count > 1}.count
    @total_students             = Role.where(:name => 'student').count
    @total_teachers             = Role.where(:name => 'teacher').count

    @total_courses              = Course.count
    @paying_courses             = Course.where('price != 0').count
    @free_courses               = Course.where('price = 0').count
    @happened_courses           = Course.where("happening = true").count
    
    @total_transaction          = Payment.select('SUM(amount) as sum').first.sum.to_f
    @total_transaction_count    = Payment.count
    @amazon_fees                = @total_transaction * 0.029 + @total_transaction_count * 0.3
    @teachers_share             = @total_transaction * 0.85
    
    @users_by_month             = User.group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").count
    @courses_by_month           = Course.unscoped.group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").count
    # @courses_by_month_austin    = Course.unscoped.joins(:city).where("cities.name = 'Austin'").group("extract( month from DATE(courses.created_at)) ").count
    # students and teachers who attended a class this month
    @students_by_month          = Role.where(:name => 'student').group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").count
    @teachers_by_month          = Role.where(:name => 'teacher').group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").count
    @transaction_by_month       = Payment.group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").sum('amount')
    @transaction_count_by_month = Payment.group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").count
    # @amazon_fees_by_month       = @transaction_by_month * 0.029 + @transaction_count_by_month * 0.3
    # @teachers_share_by_month    = @transaction_by_month * 0.85
    # @revenue_by_month           = @transaction_by_month - @amazon_fees_by_month - @teachers_share_by_month

  end
  

end
