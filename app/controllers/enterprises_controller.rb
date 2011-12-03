class EnterprisesController < ApplicationController
  before_filter :authenticate_member!
  def index
  end

  def show
  end

  def learn
    @name = current_member.org
    @enterprise = Enterprise.find_by_name(@enterprise)
    date = Date.today
    #get 10 classes this week
    @classes_this_week = @enterprise.ecourses.where('date BETWEEN ? AND ? ', date, date.advance(:weeks => 1)).limit(10)
    @all_classes_this_week = @enterprise.ecourses.where('date BETWEEN ? AND ? ', date, date.advance(:weeks => 1)).all
    # @classes_this_week = @classes_this_week[0..9] unless @classes_this_week.size < 10
    @top_suggestions =  Esuggestion.tally(
      {  :at_least => 1,
          :at_most => 10000,
          :limit => 10,
          :order => "esuggestions.name DESC"
      })
     # p @top_suggestions
      @random_course = @all_classes_this_week[rand(@all_classes_this_week.size-1) + 1]
  end

  def teach

  end

end
