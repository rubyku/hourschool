class Suggestions::NominationsController < ApplicationController
  before_filter :authenticate_user!


  def new
    @req = Suggestion.find(params[:suggestion_id])
  end


  def create
    invalid_email = (params[:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/).nil?
    if invalid_email || params[:message].blank?
      flash[:error] = "Invalid Recipient and/or Message. Can not be blank!"
      redirect_to :back
    else
      UserMailer.send_nominate_mail_to_teacher(params[:email],current_user,params[:reqid],params[:message]).deliver
      @suggestion = Suggestion.find(params[:reqid])
      flash[:notice] = "Your message has successfully been sent"
      redirect_to @suggestion
    end
  end
end
