class SitesController < ApplicationController
  skip_before_filter :limit_subdomain_access
  
  def show
    begin
      @site = Site.find_by_name!(request.subdomain)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url(:subdomain => false)
    end
  end
  
  

end
