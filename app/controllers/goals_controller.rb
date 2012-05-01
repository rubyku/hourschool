class GoalsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create,:udpate, :edit]

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.create(params[:goal])
    @goal.city = City.find_or_create_by_name_and_state(current_user.city, current_user.state)
    @goal.roles.create(:name => 'teamleader', :user => current_user)
    redirect_to @goal
  end

  def show
    @goal = goal_for_user(params[:id])
  end

  def edit
    @goal = goal_for_user(params[:id])
  end

  def update
    @goal = goal_for_user(params[:id])
    @goal.update_attributes(params[:goal])
    redirect_to @goal
  end

  def index
    @goals.inspect
    @goals = Goal.order("created_at DESC")
  end

  private

  def goal_for_user(goal_id)
    goal = Goal.find(goal_id)
    role = Role.where(:user_id => current_user.id, :course_id => goal.id)
    goal = nil if role.blank?
    return goal
  end

end
