class RegistrationsController < Devise::RegistrationsController
  # Over-riding update, all other actions are handled by Devise::RegistrationsController (the parent)
  # If you're calling any other action you can leave it blank, or call super on it

  def new
    super
  end

  def create
    if current_account.present? && current_account.invalid_email?(params[:user][:email])
        params[:user][:email] = nil
        flash[:error]         = "This is not a valid #{current_account.name} email address"
        resource              = build_resource(params[:user])
        respond_with_navigational(resource){ render_with_scope :new }
    else
      super
    end
  end

  def update
    resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    # Override Devise to use update_attributes instead of update_with_password.
    # This is the only change we make.
    if resource.update_attributes(params[resource_name])
      set_flash_message :notice, :updated
      # Line below required if using Devise >= 1.2.0
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end

  protected
    def after_update_path_for(resource)
      "/profile"
    end

    def after_sign_up_path_for(resource)
      # previous_path_or(resource)
      after_register_path(:confirm_password)
    end
end