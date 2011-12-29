require 'will_paginate/array'
class HomeController < ApplicationController
  layout nil
  layout 'application', :except => :index
  before_filter :authenticate_user!, :only => [:nominate, :nominate_send]

  before_filter :skip_if_logged_in, :only => :index

  def index
    @fav2 = Course.find(179)
    @fav1 = Course.find(180)
    @fav3 = Course.find(187)
    @fav4 = Course.find(168)
  end

  def teach
  end

  def nominate
    @req = Suggestion.find(params["id"])
  end

  def nominate_send
    if invalid_email? || params[:message].blank? then
      flash[:error] = "Invalid Recipient and/or Message. Can not be blank!"
      redirect_to :action => 'nominate', :id => params[:reqid]
    else
    UserMailer.send_nominate_mail_to_teacher(params[:email],current_user,params[:reqid],params[:message]).deliver
    UserMailer.send_nominate_mail_to_hourschool(params[:email],current_user,params[:reqid],params[:message]).deliver
    @suggestion = Suggestion.find(params[:reqid])
    flash[:notice] = "Your message has successfully been sent"
    redirect_to @suggestion
    end
  end

  private

  def invalid_email?
    (params[:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/).nil?
  end
end
