class Admin::SettingsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @account = current_account
  end

end