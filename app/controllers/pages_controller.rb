class PagesController < ApplicationController
  layout 'application', :except => :index

  # homepage
  def index
    # @featured_courses = Course.where(:featured => true).order("created_at desc").first(4)
    @fav2 = Course.find(256)
    @fav1 = Course.find(337)
    @fav3 = Course.find(240)
    @fav4 = Course.find(237)
    render :layout => 'home'
  end

  def show
    @exception = env["action_dispatch.exception"]
    if params[:id] == "campaign"
      @amount_raised = Payment.joins(:course).where("courses.donate = 'true'").select('SUM(amount) as sum').first.sum.to_f
    end
    render "pages/show/#{params[:id]}" # %w{about apps contact ...}
  end

end
