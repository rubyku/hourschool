class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # if current_user
    #   @user = current_user
    #   @user.update_facebook_from_oauth(env["omniauth.auth"])
    #   cookies[:ignoreFacebookReconnect] = true
    # else
      # You need to implement the method below in your model
      @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    # end
    sign_in(@user, :bypass => true) # needed for devise
    @user.remember_me!
    if @user.zip.present?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      redirect_to after_sign_in_path_for @user
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