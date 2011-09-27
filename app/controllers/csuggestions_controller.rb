class CsuggestionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create,:new,:udpate, :vote]
  before_filter :has_not_created_suggestion_recently?, :only => [:new, :create]
  
  def index
    @csuggestions = Csuggestion.all
  end

  def show
    @csuggestion = Csuggestion.find(params[:id])
  end

  def new
    @csuggestion = Csuggestion.new
  end

  def create
    @csuggestion = Csuggestion.new(params[:csuggestion].merge({:requested_by => current_user.id}))
    @user = current_user
    #need to have validations
    if @csuggestion.save
      
      redirect_to @csuggestion, :notice => "Successfully created csuggestion."
    else
      render :action => 'new'
    end
  end

  def edit
    @csuggestion = Csuggestion.find(params[:id])
  end

  def update
    @csuggestion = Csuggestion.find(params[:id])
    if @csuggestion.update_attributes(params[:csuggestion])
      redirect_to @csuggestion, :notice  => "Successfully updated csuggestion."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @csuggestion = Csuggestion.find(params[:id])
    @csuggestion.destroy
    redirect_to csuggestions_url, :notice => "Successfully destroyed csuggestion."
  end
  
  def vote
    votefor_id = params[:csid]
    @csuggestion = Csuggestion.find(votefor_id)
    current_user.vote_for(@csuggestion) unless current_user.voted_on?(@csuggestion)
  end
  
  protected
   def has_not_created_suggestion_recently?
      #has to be 30 minutes before requesting a suggestion
      cuser_suggestions = Csuggestion.where(:requested_by => "#{current_user.id}").first(:order => 'created_at DESC')
      if !cuser_suggestions.nil?
        wait_time = ((Time.now - cuser_suggestions.created_at)/60).ceil
        if wait_time < 5
          redirect_to current_user, :alert => "Please wait for another #{5 - wait_time} minutes before requesting"
        end
      end
    end
end
