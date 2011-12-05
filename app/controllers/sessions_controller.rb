class SessionsController < Devise::SessionsController
  def new
    store_location
    super
  end

  def create
    user = User.where(:email => params[:user][:email]).first
    user.convert_legacy_password!(params[:user][:password]) if user.present? && user.has_legacy_password?
    super
  end

end