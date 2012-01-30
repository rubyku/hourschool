class PagesController < ApplicationController
  layout 'home', :only => :index

  # homepage
  def index
    @fav2 = Course.find(308)
    @fav1 = Course.find(244)
    @fav3 = Course.find(240)
    @fav4 = Course.find(237)
  end

  def show
    render "pages/show/#{params[:id]}" # %w{about apps contact ...}
  end

end
