class PagesController < ApplicationController
  # homepage
  def index
  end

  def show
    render "pages/show/#{params[:id]}" # %w{about apps contact ...}
  end

end
