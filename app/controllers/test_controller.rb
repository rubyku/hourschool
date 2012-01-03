## Used for development testing only, use in a branch only and never commit controller or view to master
class TestController < ApplicationController
  before_filter :authenticate_admin!

  def index
    
  end

end