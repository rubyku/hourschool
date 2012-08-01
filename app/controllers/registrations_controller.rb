class RegistrationsController < Devise::RegistrationsController
  # Over-riding update, all other actions are handled by Devise::RegistrationsController (the parent)
  # If you're calling any other action you can leave it blank, or call super on it

  def new
    super
  end

  # override create so we can create account membership
  # if on a non-community site
  def create
    build_resource
    resource.dont_send_reg_email = true
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        Membership.create!(:user => resource, :account => current_account) if current_account
        resource.send_reg_email
        respond_with resource, :location => redirect_location(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new }
    end
  end

  def update
    resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    if params[:stripeToken].present?
      if resource.stripe_customer
        stripe_customer = resource.stripe_customer
        stripe_customer.card = params[:stripeToken]
        stripe_customer.save
      else
        resource.create_stripe_customer(
          :card => params[:stripeToken],
          :description => "user_#{resource.id}",
          :email => resource.email
        )
      end
    end

    # Override Devise to use update_attributes instead of update_with_password.
    # This is the only change we make.
    if resource.update_attributes(params[resource_name])
      set_flash_message :notice, :updated
      # Line below required if using Devise >= 1.2.0
      sign_in resource_name, resource, :bypass => true
      redirect_to :back
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end

  protected
    def after_update_path_for(resource)
      dashboards_path
    end

    def after_sign_up_path_for(resource)
      # previous_path_or(resource)
      #after_register_path(:confirm_password)
      dashboards_path
    end
end