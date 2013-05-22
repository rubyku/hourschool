class Admin::PaymentsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @courses = current_account ? current_account.courses.order('DATE(starts_at) DESC').where(:status => "live") : Course.order('DATE(starts_at) DESC').where(:status => "live")
  end

end