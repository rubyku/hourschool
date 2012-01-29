require 'will_paginate/array'
class HomeController < ApplicationController
  layout nil
  layout 'application', :except => :index
  before_filter :authenticate_user!, :only => [:nominate, :nominate_send]

  def index
    @fav2 = Course.find(308)
    @fav1 = Course.find(244)
    @fav3 = Course.find(240)
    @fav4 = Course.find(237)
  end

  def teach
  end


end
