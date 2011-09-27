class HomeController < ApplicationController
  
  def index
    p current_member
  end
  
  def learn
    @location = params[:location]
    date = Date.today
    #get 10 classes this week
    @classes_this_week = Course.where('date BETWEEN ? AND ?', date, date.advance(:weeks => 1)).all[0..9]
    @top_suggestions =  Csuggestion.tally(
      {  :at_least => 0,
          :at_most => 10000,
          :limit => 10,
          :order => "csuggestions.name DESC"
      })
      p @top_suggestions
      
  end
  
  def teach
  end

end
