class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    if params[:id].nil?
      @user = current_user
    else
      
      @user = User.find(params[:id])
    end
  end

end
