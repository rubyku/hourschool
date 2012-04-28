class Goals::TeammatesController < ApplicationController
  before_filter :authenticate_user!, :except => [:new]

  def new
    @goal = Goal.find(params[:goal_id])
  end

  def create
    @goal = Goal.find(params[:goal_id])
    @goal.add_teammate(current_user)
    redirect_to @goal
  end

end