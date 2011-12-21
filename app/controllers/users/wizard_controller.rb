class Users::WizardController < ApplicationController

  before_filter :authenticate_user!

  def show
    @user = current_user
    @step = params[:id].to_sym
    @next_step = next_step(@step)||:finish
    case @step
    when :confirm_password
      redirect_to_next(@next_step) and return nil unless @user.facebook?
    when :invite_fb
      redirect_to_next(@next_step) and return nil unless @user.facebook?
    end
    render_step @step
  end

  def update
    @user = current_user
    @step = params[:id].to_sym
    @next_step = next_step(@step)
    case @step
    when :confirm_password
      @user.update_attributes(params[:user])
    when :confirm_profile
      @user.update_attributes(params[:user])
    end
    sign_in(@user, :bypass => true) # needed for devise
    if @user.save
      redirect_to_next(@next_step)
    else
      render_step @step
    end
  end

  private

  def render_step(step)
    if step.nil? || step == :finish
      redirect_to_finish
    else
      render step
    end
  end


  def steps
    [:confirm_password, :invite_fb]
  end

  def next_step(current_step)
    @index = steps.index(current_step)
    if @index.present? && @index < steps.length
      return steps.at(@index + 1)
    else
      return nil
    end
  end

  def redirect_to_next(next_step)
    if next_step.nil?
      flash[:notice] = "User information successfully updated!"
      redirect_to_finish
    else
      redirect_to wizard_path(next_step)
    end
  end

  def redirect_to_finish
    puts "================="
    redirect_to previous_path_or(learn_path)
  end
end