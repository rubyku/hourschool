class Users::Facebook::ShareController < ApplicationController

  before_filter :verify_facebook, :populate_friends

  def index
    respond_to do |format|
      format.html { render :partial => 'users/facebook/grid/friend', :collection => @friends }
      format.json { render :json  => @friends.to_json }
    end
  end

  def show
    render :partial => 'users/facebook/grid/friend', :object => next_facebook_friend_for_current
  end

  def create
    options = format_parameters_for_facebook(params)
    current_user.facebook_wall_post(options) if Rails.env.production? ## don't send in development
    render :partial => 'users/facebook/grid/friend', :object => next_facebook_friend_for_current
  end

  private
    def format_parameters_for_facebook(params = {})
      options               = {}
      options[:id]          = params[:id]                                               # who you're sending the message to
      options[:message]     = params[:message]                                          # message of the post
      options[:link]        = params[:link]        unless params[:link].blank?          # url of link
      options[:name]        = params[:name]        unless params[:name].blank?          # name of link
      options[:description] = params[:description] unless params[:description].blank?
      options
    end


    def populate_friends
      friends = current_user.cache(:fetch, :expire => 12.hours).full_facebook_friends
      friends = friends.shuffle # unfreeze from cache, and randomize
      friends = friends.select {|fb_friend| current_user.in_the_same_city_fb?(fb_friend) }        if params[:same_city].present?
      friends = friends.select {|fb_friend| !params[:dismissed_ids].include? fb_friend['id']}     if params[:dismissed_ids].present?
      friends = friends.pop(params[:limit].to_i)                                                  if params[:limit].present?
      @friends = friends
    end

    def next_facebook_friend_for_current
      @friends.first
    end

    def verify_facebook
      render :text => '' if current_user.blank? || !current_user.facebook?
      return false
    end

end