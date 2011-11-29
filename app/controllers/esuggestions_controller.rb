class EsuggestionsController < ApplicationController
  skip_before_filter :limit_subdomain_access
  before_filter :authenticate_member!
  before_filter :has_not_created_suggestion_recently?, :only => [:new, :create]

  def index
    @esuggestions = Esuggestion.all
  end

  def show
    @esuggestion = Esuggestion.find(params[:id])
  end

  def new
    @esuggestion = Esuggestion.new
  end

  def create
    @esuggestion = Esuggestion.new(params[:esuggestion].merge({:requested_by => current_member.id}))
    @member = current_member
    #need to have validations
    if @esuggestion.save
      #add to enterprise
      ent = Enterprise.find_or_create_by_name_and_domain(@member.org, @member.domain)
      ent.esuggestions << @esuggestion
      ent.save
      current_member.vote_for(@esuggestion)
      redirect_to @esuggestion, :notice => "Successfully created request."
    else
      render :action => 'new'
    end
  end

  def edit
    @esuggestion = Esuggestion.find(params[:id])
  end

  def update
    @esuggestion = Esuggestion.find(params[:id])
    if @esuggestion.update_attributes(params[:esuggestion])
      redirect_to @esuggestion, :notice  => "Successfully updated request."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @esuggestion = Esuggestion.find(params[:id])
    @member = current_member
    #remove from enterprise
    ent = Enterprise.find_or_create_by_name_and_domain(@member.org, @member.domain)
    ent.esuggestions.delete(@esuggestion)
    ent.save
    @esuggestion.destroy

    redirect_to esuggestions_url, :notice => "Successfully destroyed request."
  end

  def vote
    votefor_id = params[:esid]
    @esuggestion = Esuggestion.find(votefor_id)
    current_member.vote_for(@esuggestion) unless current_member.voted_on?(@esuggestion)
  end

  protected
   def has_not_created_suggestion_recently?
      #has to be 30 minutes before requesting a suggestion
      euser_suggestions = Esuggestion.where(:requested_by => "#{current_member.id}").first(:order => 'created_at DESC')
      if !euser_suggestions.nil?
        wait_time = ((Time.now - euser_suggestions.created_at)/60).ceil
        if wait_time < 5
          redirect_to current_member, :alert => "Please wait for another #{5 - wait_time} minutes before requesting"
        end
      end
    end
end
