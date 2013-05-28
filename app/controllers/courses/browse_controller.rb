class Courses::BrowseController < ApplicationController

  def index
    @account = current_account
    if community_site?
      @upcoming_courses = Course.active.order(:starts_at, :created_at).where("starts_at > (?)", Time.zone.now)
      @past_courses = Course.order('DATE(starts_at) DESC').where(:status => "live").where("starts_at < (?)", Time.zone.now)

      @austin_courses = Course.active.order(:starts_at, :created_at).where("starts_at > (?)", Time.zone.now).where(:city_id => 111639)
      @annarbor_courses = Course.active.order(:starts_at, :created_at).where("starts_at > (?)", Time.zone.now).where(:city_id => 114765)

      if current_user
        @no_courses_in_user_city = current_user.city.try(:name).nil? || current_user.city.courses.empty?
      else
        @no_courses_in_user_city = false
      end
    else
      @upcoming_courses = Course.active.order(:starts_at, :created_at).where("starts_at > (?)", Time.zone.now).where(:account_id => current_account.id)
      @past_courses = Course.order('DATE(starts_at) DESC').where(:status => "live").where("starts_at < (?)", Time.zone.now).where(:account_id => current_account.id)
    end
    #@courses = @courses.paginate(:page => params[:page], :per_page => 99)

  end


  # courses/browse/search_by_city


  def show
    if current_user
      @no_courses_in_user_city = current_user.city.try(:name).nil? || current_user.city.courses.empty?
    else
      @no_courses_in_user_city = false
    end

    courses  = Course.live.includes(:roles, [:roles => :user])
    if params[:id] == 'all'
      courses = courses.random
    else
      courses = courses.active.order(:starts_at, :created_at)
    end
    if community_site?
      courses = courses.community
    else
      courses = courses.where(:account_id => current_account.id)
    end
    courses  = courses.located_in(params[:city])         if params[:city].present?
    courses  = courses.tagged_with(params[:tag])         if params[:tag].present?
    @courses = courses.paginate(:page => params[:page], :per_page => 99)
    @params  = params
  end

end