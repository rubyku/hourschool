class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    if @user && @user != "ec-not-supported"
      
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      if @user.nil?
        session["devise.facebook_data"] = env["omniauth.auth"]
        redirect_to new_user_registration_url, :alert => "Your facebook profile does not contain all the necessary information for creating your account. Please register."
      end
      if @user == "ec-not-supported"
        redirect_to root_path, :alert => "We are sorry. There are no hourschools in your area yet."
      end
    end
  end
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end