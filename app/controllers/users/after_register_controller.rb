class Users::AfterRegisterController < Wicked::WizardController
  before_filter :authenticate_user!
  steps :confirm_password, :confirm_avatar, :invite_fb, :confirm_after_twitter


  def show
    @user = current_user
    case @step
    when :confirm_password
      skip_step unless @user.facebook?
    when :confirm_avatar
      skip_step if @user.photo?
    when :invite_fb
      if @user.facebook?
        @user.cache(:fetch, :expire => 12.hours).raw_facebook_friends.shuffle # warm cache for ajax call
      else
        skip_step
      end
    end
    render_wizard
  end

  def update
    @user = current_user
    case @step
    when :confirm_password
      @user.update_attributes(params[:user])
    when :confirm_avatar
      @user.update_attributes(params[:user])
    when :confirm_profile
      @user.update_attributes(params[:user])
    when :confirm_after_twitter
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