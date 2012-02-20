class PagesController < ApplicationController
  layout 'application', :except => :index

  # homepage
  def index
    # @featured_courses = Course.where(:featured => true).order("created_at desc").first(4)
    @fav2 = Course.where(:id => 382).first || Course.live.random.first
    @fav1 = Course.where(:id => 385).first || Course.live.random.first
    @fav3 = Course.where(:id => 318).first || Course.live.random.first
    @fav4 = Course.where(:id => 371).first || Course.live.random.first
    render :layout => 'home'
  end

  def show
    @exception = env["action_dispatch.exception"]
    if params[:id] == "campaign"
      @amount_raised = Payment.joins(:course).where("courses.donate = 'true'").select('SUM(amount) as sum').first.sum.to_f
    end
    render "pages/show/#{params[:id]}" # %w{ about apps contact ... }
  end

end
