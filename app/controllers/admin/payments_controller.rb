class Admin::PaymentsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @courses = current_account.courses
  end

end