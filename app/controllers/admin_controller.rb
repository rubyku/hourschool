class AdminController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @courses = current_account ? current_account.courses.order('DATE(starts_at) DESC').where(:status => "live") : Course.order('DATE(starts_at) DESC').where(:status => "live")
    @users   = current_account ? current_account.users.uniq : User.uniq.includes(:memberships, [:memberships => :account])

    @course  = Course.new
    @invite  = Invite.new

    @users_by_month       = User.uniq.includes(:memberships, [:memberships => :account]).group("extract( YEAR from DATE(created_at))").group("extract( MONTH from DATE(created_at))").order("extract( YEAR from DATE(created_at)) DESC").order("extract( MONTH from DATE(created_at)) DESC").count
    @registrations_by_day =  Role.where(:name => "student").group("extract( DAY from DATE(created_at))").where("created_at > (?)", 5.days.ago.beginning_of_day).count
  end


  def show
    @users_sincelastnewsletter  = User.where("created_at > ?", '2012-05-31')
    @courses_last_month         = Course.where("extract( month from DATE(starts_at)) = 3").where("extract( year from DATE(starts_at)) = 2013").where('price != 0').where(:status => "live")

    render "admin/show/#{params[:id]}"
  end

end
