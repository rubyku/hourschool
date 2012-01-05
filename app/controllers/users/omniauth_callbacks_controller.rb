class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook

    Rails.logger.error("return to: #{session[:return_to]}")
    # if current_user
    #   @user = current_user
    #   @user.update_facebook_from_oauth(env["omniauth.auth"])
    #   cookies[:ignoreFacebookReconnect] = true
    # else
      # You need to implement the method below in your model
      @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    # end
    @user.remember_me!


    sign_in :user, @user
    sign_in(@user, :bypass => true) # needed for devise
    Rails.logger.error("=== User remembered #{@user}")
    Rails.logger.error("=== User zip: #{@user.zip.present?}")


    sign_in_path = after_sign_in_path_for @user
    Rails.logger.error("=== after_sign_in_path: remembered #{sign_in_path}")


    if @user.zip.present?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      Rails.logger.error("-- valid? #{@user.valid?}")
      Rails.logger.error("-- Save: #{@user.save}")
      Rails.logger.error("-- current_user: #{current_user.inspect}")
      Rails.logger.error("-- Signed in: #{signed_in?}")
      redirect_to  sign_in_path # after_sign_in_path_for @user
    else
      flash[:notice] = "Thanks for signing up!"
      redirect_to after_register_path(:confirm_password)
    end
  end

  def passthru
    store_referrer if session[:return_to].blank?
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end