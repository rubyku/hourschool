class Users::FacebookShareController < ApplicationController

  before_filter :verify_facebook

  def index
    @friends = current_user.cache(:fetch, :expire => 12.hours).full_facebook_friends.shuffle
    @friends = @friends.pop(params[:limit].to_i) if params[:limit].present?
    render :partial => 'friend', :collection => @friends, :locals => locals_from_params
  end

  def show
    render :partial => 'friend', :object => next_facebook_friend_for_current,  :locals => locals_from_params
  end

  def create
    options = format_parameters_for_facebook(params)
    current_user.facebook_wall_post(options) if Rails.env.production? ## don't send in development
    render :partial => 'friend', :object => next_facebook_friend_for_current,  :locals => locals_from_params
  end

  private
    def format_parameters_for_facebook(params = {})
      options           = {}
      options[:id]      = params[:id]                               # who you're sending the message to
      options[:message] = params[:message]                          # message of the post
      options[:link]    = params[:link] unless params[:link].blank? # url of link
      options[:name]    = params[:name] unless params[:name].blank? # name of link
      options
    end

    def next_facebook_friend_for_current
      current_user.cache(:fetch, :expire => 12.hours).raw_facebook_friends.sample(1).first
    end

    def locals_from_params
      {:message => params[:message], :link => params[:link], :name => params[:name]}
    end

    def verify_facebook
      render :text => '' if current_user.blank? || !current_user.facebook?
      return false
    end

end