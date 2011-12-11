class Admin::ChartsController < Admin::AdminController

  def index
    # Per day
    @users    = User.order('DATE(created_at) DESC').group("DATE(created_at)").count
    @courses  = Course.unscoped.order('DATE(created_at) DESC').group("DATE(created_at)").count
    @students = Role.where(:role => 'student').order('DATE(created_at) DESC').group("DATE(created_at)").count

    # Week over week calculations
    wow_users = @users.clone.to_a
    user_count_last_week        = wow_users.shift(7).sum {|date, count| count}

    # Totals
    @revenue        = Payment.select('SUM(amount) as sum').first.sum.to_f
    @total_users    = User.count
    @total_courses  = Course.count
    @total_students = Role.where(:role => 'student').count
    @estimated_user_count_six_months = (user_count_last_week * 4 * 6) + @total_users
  end

end
