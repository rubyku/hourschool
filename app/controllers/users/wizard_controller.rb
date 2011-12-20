class Users::WizardController < ApplicationController

  def show
    @user = current_user
    @step = params[:id].to_sym
    @next_step = next_step(@step)
    render @step
  end

  def update
    @user = current_user
    @step = params[:id].to_sym
    @next_step = next_step(@step)
    case @step
    when :confirm_password
      @user.update_with_password(params[:user])
    when :confirm_profile
      @user.update_attributes(params[:user])
    end
    @user.save
    redirect_to_next(@next_step)
  end

  private

  def steps
    [:confirm_password, :confirm_profile]
  end

  def next_step(current_step)
    @index = steps.index(current_step)
    if @index < steps.length
      return steps.at(@index + 1)
    else
      return nil
    end
  end

  def redirect_to_next(next_step)
    if next_step.nil?
      flash[:notice] = "User information successfully updated!"
      redirect_to @user
    else
      redirect_to "/wizard/#{next_step}"
    end
  end
end