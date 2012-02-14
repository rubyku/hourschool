class FollowingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @classmates = @user.classmates
    @students   = @user.students
    @teachers   = @user.teachers
  end

  def create
    @followed = User.find(params[:id])
    current_user.follow!(@followed, params[:relationship])
    redirect_to :back
  end

  def update

  end

  def destroy
    @followed = User.find(params[:id])
    following = Following.where(:followed_id => @followed, :follower_id => current_user).first
    following.destroy
    redirect_to :back
  end

end
