class Goals::NotifyController < ApplicationController
  before_filter :authenticate_user!, :except => [:new]

  def new
    @goal = Goal.find(params[:goal_id])

  end

  def create
    @goal = Goal.find(params[:goal_id])
    # Send Emails here
  end

end