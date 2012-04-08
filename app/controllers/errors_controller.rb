class ErrorsController < ApplicationController
  before_filter :capture_exception

  def not_found
    render "pages/show/errors/404", :status => 404
  end


  def error
    render "pages/show/errors/404", :status => 500
  end

  private

  def capture_exception
    @exception = env["action_dispatch.exception"]
  end

end
