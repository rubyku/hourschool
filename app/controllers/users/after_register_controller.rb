class Users::AfterRegisterController < Wicked::WizardController
  before_filter :authenticate_user!
  steps :confirm_password, :invite_fb


  def show
    @user = current_user
    case @step
    when :confirm_password
      skip_step unless @user.facebook?
    when :invite_fb
      skip_step unless @user.facebook?
    end
    render_wizard
  end

  def update
    @user = current_user
    case @step
    when :confirm_password
      @user.update_attributes(params[:user])
    when :confirm_profile
      @user.update_attributes(params[:user])
    end
    sign_in(@user, :bypass => true) # needed for devise
    render_wizard @user
  end

  protected
    def finish_wizard_path
      previous_path_or(learn_path)
    end

end