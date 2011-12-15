class ApplicationController < ActionController::Base
  rescue_from Exception, :with => :render_error unless Rails.env.development?

  include UrlHelper

  before_filter :set_timezone
  protect_from_forgery

  protected

    def must_be_signed_in
      store_location
      redirect_to root_path, :notice => "Please sign in" unless signed_in?
    end

    def must_be_admin
      store_location
      redirect_to root_path unless current_user.try(:admin?)
    end

    def log_error(exception)
      message = "#{exception.class} (#{exception.message}):\n  "
      message += Rails.backtrace_cleaner.clean(exception.backtrace).join("\\n")
      Rails.logger.fatal(message)
    end

    def render_error(exception)
      @exception = exception
      log_error(@exception)
      send_error_to_new_relic(@exception)
      respond_to do |format|
        format.html do
          case exception
          when ArgumentError, ActionView::MissingTemplate, ActiveRecord::RecordNotFound, ActionController::UnknownController, ActionController::UnknownAction
            render 'pages/show/errors/404', :status => 404
          else
            render 'pages/show/errors/404', :status => 500
          end
        end
      end
    end

    def send_error_to_new_relic(exception)
      rack_env = ENV.to_hash.merge(request.env)
      rack_env.delete('rack.session.options')

      opts = {
        :request_params => params,
        :custom_params => {
          :session => session,
          :rack => rack_env
        }
      }
      NewRelic::Agent.notice_error(exception, opts)
    end


    def skip_if_logged_in
      redirect_to learn_path if current_user.present?
    end

    def set_timezone
      Time.zone = current_user.time_zone if current_user.present? && current_user.time_zone.present?
    end

    def after_sign_in_path_for(resource)
      previous_path_or(resource)
    end


    def previous_path_or(url)
      if session[:return_to].present? && session[:return_to] != '/'
        return_to = session[:return_to]
        session[:return_to] = nil
        return_to
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
