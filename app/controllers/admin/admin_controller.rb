class Admin::AdminController < ApplicationController
  before_filter :ensure_admin
  
  def ensure_admin
    redirect_to root_path if current_user.blank? || !current_user.admin?
  end
  
  
end
