class Users::AfterRegisterController < Wicked::WizardController
  before_filter :authenticate_user!
  steps :confirm_password, :confirm_avatar, :invite_fb


  def show
    @user = current_user
    # case @step
    # when :confirm_password
    #   if @user.facebook?
    #     flash[:notice] = "Please fill out this information"
    #   else
    #     skip_step
    #   end
    # # when :confirm_zip
    # #   skip_step if @user.zip.present?
    # when :confirm_avatar
    #   skip_step if @user.photo?
    # when :invite_fb
    #   if @user.facebook?
    #     @user.cache(:fetch, :expire => 12.hours).raw_facebook_friends.shuffle # warm cache for ajax call
    #   else
    #     skip_step
    #   end
    # end

    render_wizard
  end

  def update
    @user = current_user
    params[:user][:status] = 'active'
    @user.update_attributes(params[:user])
    sign_in(@user, :bypass => true) # needed for devise
    render_wizard @user
  end

  protected
    def finish_wizard_path
      previous_path_or(root_path)
    end

end