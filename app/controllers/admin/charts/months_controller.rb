class Admin::Charts::MonthsController < Admin::AdminController

  def show
    @users_in_month =  User.where("extract( month from DATE(created_at)) = ?",  params[:id])
    @attendes_signed_up_this_month =  Role.where("extract( month from DATE(created_at)) = ?", params[:id]).where("user_id in (?)", @users_in_month.map(&:id)).select("DISTINCT(user_id)").count
    
    # select("DISTINCT(user_id)").order('extract( month from DATE(created_at)) DESC').group("extract( month from DATE(created_at)) ").count
    
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
