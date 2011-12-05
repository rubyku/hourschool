class SuggestionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create,:udpate, :vote]
  before_filter :has_not_created_suggestion_recently?, :only => [:new, :create]

  def index
    @suggestions = Suggestion.all

  end

  def suggest
    @top_suggestions =  Suggestion.tally(
       {  :at_least => 1,
           :at_most => 10000,
           :limit => 100,
           :order => "suggestions.name ASC"
       })
      @suggestions = (@top_suggestions & @suggestions_in_my_location).paginate(:page => params[:page], :per_page => 6)
      # if Course.count > 0
      #    @random_course = Course.random 
      #    @classes_we_like = Course.random.first(3)
      #  else
      #    @classes_we_like = []
      #  end
  end

  def show
    @suggestion = Suggestion.find(params[:id])
  end

  def new
    @suggestion = Suggestion.new
  end

  def create
    @suggestion = Suggestion.new(params[:suggestion].merge({:requested_by => current_user.id}))
    @user = current_user
    #need to have validations
    if @suggestion.save
      current_user.vote_for(@suggestion)
      city = City.find_or_create_by_name_and_state(current_user.city, current_user.state)
      city.suggestions << @suggestion
      city.save
      UserMailer.send_suggestion_received_to_hourschool_mail(current_user.email, current_user.name, @suggestion).deliver 
      flash[:notice] = "Thanks for suggesting a class!"
      redirect_to @suggestion
    else
      render :action => 'new'
    end
  end

  def edit
    @suggestion = Suggestion.find(params[:id])
  end

  def update
    @suggestion = Suggestion.find(params[:id])
    if @suggestion.update_attributes(params[:suggestion])
      redirect_to current_user, :notice  => "Successfully updated suggestion."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @suggestion = Suggestion.find(params[:id])
     city = City.find_or_create_by_name_and_state(current_user.city, current_user.state)
      city.suggestions.delete(@suggestion)
      city.save
    @suggestion.destroy
    redirect_to suggestions_url, :notice => "Successfully destroyed suggestion."
  end

  def vote
    votefor_id = params[:csid]
    @suggestion = Suggestion.find(votefor_id)
    current_user.vote_for(@suggestion) unless current_user.voted_on?(@suggestion)
    respond_to do |format|
      format.html {redirect_to :back}
    end
  end

  protected
   def has_not_created_suggestion_recently?
     if current_user
        cuser_suggestions = Suggestion.where(:requested_by => "#{current_user.id}").first(:order => 'created_at DESC')
        if !cuser_suggestions.nil?
          wait_time = ((Time.now - cuser_suggestions.created_at)/60).ceil
          if wait_time < 1
            flash[:error] = "Please wait for another #{5 - wait_time} minute before requesting another class"
            redirect_to "/suggest"
          end
        end
    end
  end
end
