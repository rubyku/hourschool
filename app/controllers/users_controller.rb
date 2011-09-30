class UsersController < ApplicationController
  
  def index
    @users = User.all
  end

  def show
    p current_user
    if params[:id].nil?
      @user = current_user
    else
      
      @user = User.find(params[:id])
      p current_user
    end
  end

end
