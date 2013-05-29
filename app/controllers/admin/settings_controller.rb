class Admin::SettingsController < ApplicationController
  before_filter :authenticate_admin!

  def index
  end

end