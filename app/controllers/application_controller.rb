class ApplicationController < ActionController::Base
  include UrlHelper

  protect_from_forgery
  before_filter :limit_subdomain_access

  protected

    def limit_subdomain_access
        if request.subdomain.present?
          # this error handling could be more sophisticated!
          # please make a suggestion :-)
          redirect_to root_url(:subdomain => false)
        end
    end

    def after_sign_in_path_for(resource)
       if resource.is_a?(Member)
          #p "member domain is #{resource.member_domain}"
          root_url(:subdomain => resource.member_domain )
        else
          user_root_path
        end
    end


    def previous_path_or(url)
      if session[:return_to].present? && session[:return_to] != '/'
        session[:return_to]
      else
        url
      end
    end




end
