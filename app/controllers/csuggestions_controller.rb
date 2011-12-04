class CsuggestionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create,:udpate, :vote]
  before_filter :has_not_created_suggestion_recently?, :only => [:new, :create]

  def index
    @csuggestions = Csuggestion.all

  end

  def suggest
    @top_suggestions =  Csuggestion.tally(
       {  :at_least => 1,
           :at_most => 10000,
           :limit => 100,
           :order => "csuggestions.name ASC"
       })
      @suggestions = (@top_suggestions & @suggestions_in_my_location).paginate(:page => params[:page], :per_page => 6)
      if Course.count > 0
         @random_course = Course.random

         @classes_we_like = Course.random.first(3)
       else
         @classes_we_like = []
       end
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
      current_user.vote_for(@csuggestion)
      city = City.find_or_create_by_name_and_state(current_user.city, current_user.state)
      city.csuggestions << @csuggestion
      city.save
      UserMailer.send_suggestion_received_to_hourschool_mail(current_user.email, current_user.name, @csuggestion).deliver     
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
      redirect_to current_user, :notice  => "Successfully updated csuggestion."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @csuggestion = Csuggestion.find(params[:id])
     city = City.find_or_create_by_name_and_state(current_user.city, current_user.state)
      city.csuggestions.delete(@csuggestion)
      city.save
    @csuggestion.destroy
    redirect_to csuggestions_url, :notice => "Successfully destroyed csuggestion."
  end

  def vote
    votefor_id = params[:csid]
    @csuggestion = Csuggestion.find(votefor_id)
    current_user.vote_for(@csuggestion) unless current_user.voted_on?(@csuggestion)
    respond_to do |format|
      format.html {redirect_to :back}
    end
  end

  protected
   def has_not_created_suggestion_recently?
     if current_user
        cuser_suggestions = Csuggestion.where(:requested_by => "#{current_user.id}").first(:order => 'created_at DESC')
        if !cuser_suggestions.nil?
          wait_time = ((Time.now - cuser_suggestions.created_at)/60).ceil
          if wait_time < 5
            puts "=================================="
            flash[:error] = "Please wait for another #{5 - wait_time} minutes before requesting another class"
            redirect_to current_user
          end
        end
    end
  end
end
