class RegistrationsController < Devise::RegistrationsController
  # Over-riding update, all other actions are handled by Devise::RegistrationsController (the parent)
  # If you're calling any other action you can leave it blank, or call super on it


  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated if is_navigational_format?
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource){ render_with_scope :edit }
    end
  end

  protected
    # def after_sign_up_path_for(resource)
    #   user_root_path # after we create a user, send them to /learn
    # end
end