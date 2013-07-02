class PagesController < ApplicationController
  layout 'application', :except => :index

  # homepage
  def index

    @upcoming_courses = Course.active.order(:starts_at, :created_at).where("starts_at > (?)", Time.zone.now)
    @past_courses = Course.order('DATE(starts_at) DESC').where(:status => "live").where("starts_at < (?)", Time.zone.now)

    if current_account
      @account = current_account
      @memberships = @account.memberships.order("created_at DESC").uniq
      @upcoming_courses = @upcoming_courses.where(:account_id => current_account.id)
      @past_courses = @past_courses.where(:account_id => current_account.id)
    end

    if community_site?
      if current_user
        @no_courses_in_user_city = current_user.city.try(:name).nil? || current_user.city.courses.empty?
      else
        @no_courses_in_user_city = false
      end
    end

    if community_site?
      @featured_courses = Course.active.where(:featured => true).order(:starts_at, :created_at)
    end
  end

  def show
    @account = current_account
    @mission = Mission.new
    @live_missions = Mission.where(:status => "live").where('photo_file_name is not null').where(:account_id => current_account)
    @exception = env["action_dispatch.exception"]
    if params[:id] == "campaign"
      @amount_raised = Payment.joins(:course).where("courses.donate = 'true'").select('SUM(amount) as sum').first.sum.to_f
    end
    render "pages/show/#{params[:id]}" # %w{ about apps contact ... }
  end

end
