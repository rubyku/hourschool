class SessionsController < Devise::SessionsController
  def new
    store_location
    super
  end

end