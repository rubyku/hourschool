class Users::TicketInviteController < ApplicationController
  before_filter :authenticate_user!, :only => :create

  ## Person accepting the invit hits this
  def edit
    @user = User.where(:invite_token => params[:id], :status => "invitee").first
  end


  ## Person accepting the invit hits this
  def update
    user = current_user.extra_ticket_users.where(:invite_token => params[:id], :status => "invitee").first
    role = user.roles.first
    if current_user
      role.user_id = current_user.id
      role.save
      user.destroy
    else
      user.update_attributes(params[:user])
      user.status = "claimed"
      user.save
    end
    redirect_to role.course, :notice => "Ticket claimed successfully!!"
  end

  ## Person creating the invites hits this
  def create
    ## Duplicate email path
    user = current_user.extra_ticket_users.where(:invite_token => params[:id], :status => "invitee").first
    user.update_attributes(:email => params[:user][:email], :name => params[:user][:name])

    role = user.roles.first
    UserMailer.ticket_invite(:user => user, :role => role, :inviter => current_user).deliver
    redirect_to :back
  end
end
