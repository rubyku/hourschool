class PagesController < ApplicationController
  layout 'application', :except => :index

  # homepage
  def index
    @fav2 = Course.find(308)
    @fav1 = Course.find(244)
    @fav3 = Course.find(240)
    @fav4 = Course.find(237)
    render :layout => 'home'
  end

  def show
    render "pages/show/#{params[:id]}" # %w{about apps contact ...}
  end

end
