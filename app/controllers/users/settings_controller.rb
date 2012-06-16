class Users::SettingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
  end

  def update

  end

end