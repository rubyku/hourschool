class ApplicationController < ActionController::Base
  include UrlHelper

  before_filter :set_timezone
  protect_from_forgery



  protected

    def skip_if_logged_in
      redirect_to learn_path if current_user.present?
    end

    def set_timezone
      Time.zone = current_user.time_zone if current_user.present? && current_user.time_zone.present?
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

    def store_location
      if request.url != request.referrer
        session[:return_to] = request.referrer
      end
    end


    def after_sign_in_path_for(resource)
      previous_path_or(resource)
    end

end
