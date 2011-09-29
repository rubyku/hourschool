class HomeController < ApplicationController
  
  def index
    p current_member
  end
  
  def learn
    @location = params[:location]
    date = Date.today
    #get 10 classes this week
    @classes_this_week = Course.where('date BETWEEN ? AND ?', date, date.advance(:weeks => 1)).limit(10)
    # @classes_this_week = @classes_this_week[0..9] unless @classes_this_week.size < 10
    @top_suggestions =  Csuggestion.tally(
      {  :at_least => 1,
          :at_most => 10000,
          :limit => 10,
          :order => "csuggestions.name DESC"
      })
     # p @top_suggestions
      @random_course = Course.find(rand(Course.count-1) + 1)
  end
  
  
  def teach
     @top_suggestions =  Csuggestion.tally(
        {  :at_least => 1,
            :at_most => 10000,
            :limit => 5,
            :order => "csuggestions.name DESC"
        })
       # p @top_suggestions
        @random_course = Course.find(rand(Course.count-1) + 1)
  end
  
  def search_by_tg
    keyword =  TAGS[params[:index].to_i]
    #results = TBACKUP.search "tags:#{keyword}", {:fetch => 'cid'}
    date = Date.today
    #find classes tagged with that
    @classes_this_week = Course.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 1)).tagged_with("#{keyword}").limit(10)
    
  end
  
  def organization
  end

end
