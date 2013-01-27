class Users::TicketInviteController < ApplicationController
  before_filter :authenticate_user!, :only => :create

  ## Person accepting the invit hits this
  def edit
    @invite_user = User.where(:invite_token => params[:id], :status => "invitee").first
    @role        = @invite_user.roles.first
    @inviter     = User.where(:id => @role.invite_user_id).first
    @course      = @role.course
    @user        = User.new(params[:user])
    store_location
  end

  ## Person accepting the invite hits this
  def update
    user = User.where(:invite_token => params[:id], :status => "invitee").first
    role = user.roles.first
    if current_user
      role.user_id = current_user.id
      role.save
      user.delete
    end
    redirect_to role.course, :notice => "Ticket claimed successfully!"
  end

  ## Person creating the invites hits this
  def create
    ## Duplicate email path
    @user = User.where(:invite_token => params[:id], :status => "invitee").first
    @user.update_attributes(:email => params[:user][:email], :name => params[:user][:name])

    @role = @user.roles.first
    UserMailer.ticket_invite(:user => @user, :role => @role, :inviter => current_user).deliver
    redirect_to :back
  end
end
