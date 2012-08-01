class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
# https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview


  def facebook
    if current_user
      @user = current_user
      @user.update_facebook_from_oauth(env["omniauth.auth"])
      cookies[:ignoreFacebookReconnect] = true
    else
      @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    end
    session["devise.facebook_data"] = request.env["omniauth.auth"]
    @user.remember_me = true
    @user.save
    sign_in_and_redirect @user, :event => :authentication

    # sign_in(@user, :bypass => true) # needed for devise
    # @user.remember_me!

    # if a user doesn't have a zipcode (new users) send them to the wizard (after_register_path)
    # if @user.zip.present?
    #   flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
    #   sign_in_and_redirect @user, :event => :authentication
    # else
    #   sign_in(@user, :event => :authentication)
    #   redirect_to after_register_path(:confirm_password)
    # end
  end

  def passthru
    store_referrer if session[:return_to].blank?
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end