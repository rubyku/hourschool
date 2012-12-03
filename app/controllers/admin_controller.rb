class AdminController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @courses = current_account ? current_account.courses.order('DATE(starts_at) DESC').where(:status => "live") : Course.order('DATE(starts_at) DESC').where(:status => "live")

    if community_site?
      @users = User.order('DATE(created_at) DESC').includes(:memberships, [:memberships => :account])
    else
      @users = current_account.users.uniq
    end

    @course = Course.new
    @topic = Topic.new
    @invite = Invite.new

  end


  def show
    @users_sincelastnewsletter  = User.where("created_at > ?", '2012-05-31')
    @courses_last_month         = Course.where("extract( month from DATE(starts_at)) = 11").where("extract( year from DATE(starts_at)) = 2012").where('price != 0').where(:status => "live")

    render "admin/show/#{params[:id]}"
  end

end
