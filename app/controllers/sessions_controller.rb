class SessionsController < Devise::SessionsController
  skip_before_filter :hide_private_accounts

  def new
    resource = build_resource
    clean_up_passwords(resource)
    if current_account && current_account.private?
      render 'new_private', :layout => false
    else
      respond_with_navigational(resource, stub_options(resource)){ render_with_scope :new }
    end
  end

  def create
    user = User.where(:email => params[:user][:email]).first
    user.convert_legacy_password!(params[:user][:password]) if user.present? && user.has_legacy_password?
    super
  end

end