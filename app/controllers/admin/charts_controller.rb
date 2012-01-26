class Admin::ChartsController < Admin::AdminController

  def index
    # Per day
    @users    = User.order('DATE(created_at) DESC').group("DATE(created_at)").count
    @courses  = Course.unscoped.order('DATE(created_at) DESC').group("DATE(created_at)").count
    @students = Role.where(:name => 'student').order('DATE(created_at) DESC').group("DATE(created_at)").count


    @teachers = User.joins(:roles).where("roles.name = 'teacher'").order('DATE(roles.created_at) DESC')

    # Per month
    @users_by_month             = User.order('extract( month from DATE(created_at)) DESC').group("extract( month from DATE(created_at)) ").count
    @courses_by_month           = Course.unscoped.group("extract( month from DATE(created_at)) ").count
    @courses_by_month_austin    = Course.unscoped.joins(:city).where("cities.name = 'Austin'").group("extract( month from DATE(courses.created_at)) ").count
    @students_by_month          = Role.where(:name => 'student').group("extract( month from DATE(created_at)) ").count
    @transaction_by_month       = Payment.group("extract( month from DATE(created_at))").sum('amount')
    @transaction_count_by_month = Payment.group("extract( month from DATE(created_at))").count
    # @amazon_fees_by_month       = @transaction_by_month * 0.029 + @transaction_count_by_month * 0.3
    # @teachers_share_by_month    = @transaction_by_month * 0.85
    # @revenue_by_month           = @transaction_by_month - @amazon_fees_by_month - @teachers_share_by_month

    # Week over week calculations
    wow_users = @users.clone.to_a
    user_count_last_week        = wow_users.shift(7).sum {|date, count| count}

    # Totals
    @total_transaction          = Payment.select('SUM(amount) as sum').first.sum.to_f
    @total_transaction_count    = Payment.count
    @total_users                = User.count
    @total_fb_users             = User.where("fb_token is not null").count
    @total_courses              = Course.count
    @total_students             = Role.where(:name => 'student').count
    @total_teachers             = Role.where(:name => 'teacher').count

    @paying_courses = Course.where('price != 0').count
    @free_courses   = Course.where('price = 0').count
    @amazon_fees    = @total_transaction * 0.029 + @total_transaction_count * 0.3
    @teachers_share = @total_transaction * 0.85
  end


end
