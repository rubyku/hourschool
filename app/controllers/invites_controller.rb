class InvitesController < ApplicationController
  before_filter :authenticate_user!, :only => :create

  # GET /invites
  # GET /invites.json
  def index
    @invites = Invite.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invites }
    end
  end

  # GET /invites/1
  # GET /invites/1.json
  def show
    @invite = Invite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invite }
    end
  end

  # GET /invites/new
  # GET /invites/new.json
  def new
    @invite = Invite.new
    @invite.invitable_id = params[:invitable_id]
    @invite.invitable_type = params[:invitable_type]
    @invite.inviter = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invite }
    end
  end

  # GET /invites/1/edit
  def edit
    @invite = Invite.find(params[:id])
  end

  # POST /invites
  # POST /invites.json

  def create
    if params[:invite_selection]
      params[:invite][:invitable_type], params[:invite][:invitable_id] = params.delete(:invite_selection).split(":")
    end

    # params = {:invite => {:inviter_id => 4, :invitee_id => 4}}

    @invite = current_user.sent_invites.new(params[:invite])

    respond_to do |format|
      if @invite.save
        if @invite.invitable_type.downcase == 'mission'
          if @invite.inviter_id.present?
            UserMailer.user_invite_to_mission(:inviter => @invite.inviter, :mission => Mission.find(@invite.invitable_id), :invitee_email => @invite.invitee_email, :message => @invite.message).deliver
          else
            UserMailer.nonuser_invite_to_mission(:inviter_name => @invite.inviter_name, :inviter_email => @invite.inviter_email, :mission => Mission.find(@invite.invitable_id), :invitee_email => @invite.invitee_email, :message => @invite.message).deliver
          end
        elsif @invite.invitable_type.downcase == "course"
          if @invite.inviter_id.present?
            UserMailer.user_invite_to_course(:inviter => @invite.inviter, :course => Course.find(@invite.invitable_id), :invitee_email => @invite.invitee_email, :message => @invite.message).deliver
          else
            UserMailer.nonuser_invite_to_course(:inviter_name => @invite.inviter_name, :inviter_email => @invite.inviter_email, :course => Course.find(@invite.invitable_id), :invitee_email => @invite.invitee_email, :message => @invite.message).deliver
          end
        elsif @invite.invitable_type.downcase == "comment"
          if @invite.inviter_id.present?
            UserMailer.user_invite_to_comment(:inviter => @invite.inviter, :comment => Comment.find(@invite.invitable_id), :invitee_email => @invite.invitee_email, :message => @invite.message).deliver
          else
            UserMailer.nonuser_invite_to_comment(:inviter_name => @invite.inviter_name, :inviter_email => @invite.inviter_email, :comment => Comment.find(@invite.invitable_id), :invitee_email => @invite.invitee_email, :message => @invite.message).deliver
          end
        elsif @invite.invitable_type.downcase == "topic"
          if @invite.inviter_id.present?
            UserMailer.user_invite_to_topic(:inviter => @invite.inviter, :topic => Topic.find(@invite.invitable_id), :invitee_email => @invite.invitee_email, :message => @invite.message).deliver
          else
            UserMailer.nonuser_invite_to_topic(:inviter_name => @invite.inviter_name, :inviter_email => @invite.inviter_email, :topic => Topic.find(@invite.invitable_id), :invitee_email => @invite.invitee_email, :message => @invite.message).deliver
          end
        end

        format.html { redirect_to :back, notice: 'Invite was successfully sent.' }
        format.json { render json: @invite, status: :created, location: @invite }
      else
        format.html { render action: "new" }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invites/1
  # PUT /invites/1.json
  def update
    @invite = Invite.find(params[:id])

    respond_to do |format|
      if @invite.update_attributes(params[:invite])
        format.html { redirect_to @invite, notice: 'Invite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invites/1
  # DELETE /invites/1.json
  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy

    respond_to do |format|
      format.html { redirect_to invites_url }
      format.json { head :no_content }
    end
  end
end
