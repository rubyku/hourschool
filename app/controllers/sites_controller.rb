class SitesController < ApplicationController
  
  skip_before_filter :limit_subdomain_access
   before_filter :authenticate_member!
   before_filter :correct_member
  
  def show
    begin
      @site = Site.find_by_name!(request.subdomain)
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url(:subdomain => false)
    end
    
  end
  
  protected
  def correct_member
    site = Site.find_by_name!(request.subdomain)
    index1 = current_member.email.index('@')
    index2 = current_member.email.index('.com')
    
    p site.enterprise.domain
    redirect_to root_url(:subdomain => false) unless current_member.email[index1+1..index2-1] == site.enterprise.domain
  end

end
