require 'will_paginate/array'
class HomeController < ApplicationController
  
  def index
    if current_user
      redirect_to current_user
    end
  end
  
  def learn
    
    @location = params[:location]
    if params[:page].nil? 
      session[:location] = params[:location]
    end
    if params[:location].nil? || params[:location].blank?
      @location = session[:location]
    end
    date = Date.today
    #get 10 classes this week
    @classes_this_week = Course.where('date BETWEEN ? AND ?', date, date.advance(:weeks => 1)).find(:all).paginate(:page => params[:page], :per_page => 6)
    # @classes_this_week = @classes_this_week[0..9] unless @classes_this_week.size < 10
    @top_suggestions =  Csuggestion.tally(
      {  :at_least => 1,
          :at_most => 10000,
          :limit => 10,
          :order => "csuggestions.name DESC"
      })
     # p @top_suggestions
      @random_course = Course.find(rand(Course.count-1) + 1)
      @classes_we_like = []
      (1..2).each do |val|
        @classes_we_like << Course.find(rand(Course.count-1) + 1)
      end
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
        @classes_we_like = []
        (1..2).each do |val|
          @classes_we_like << Course.find(rand(Course.count-1) + 1)
        end
  end
  
  def search_by_tg
    keyword =  TAGS[params[:index].to_i]
    #results = TBACKUP.search "tags:#{keyword}", {:fetch => 'cid'}
    date = Date.today
    #find classes tagged with that
    @classes_this_week = Course.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 1)).tagged_with("#{keyword}").find(:all).paginate(:page => params[:page], :per_page => 6)
     @classes_we_like = []
      (1..2).each do |val|
        @classes_we_like << Course.find(rand(Course.count-1) + 1)
      end
  end
  
  def organization
  end
  
  def community
  end
  
  def community_faq
  end
  
  def business
  end
  
  def contactus
  end
  
  def search
    #default location is austin, if i don't find a location in my session_variable
    date = Date.today
    if session[:user_location].nil? || session[:user_location].blank?
      user_location = "Austin"
    else
      user_location = session[:user_location]
    end
    
    @all_courses_in_city = City.find(:first, :conditions => ["name LIKE ?", "#{user_location}"]).courses
    #the sql query description like "%string%" will return a list of all courses
    #let us return everything and then filter it by city
    search_string = "%#{params[:search]}%"
    if search_string.nil? || search_string.blank?
      search_string = session[:search_string]
    end
    if params[:page].nil?
      session[:search_string] = search_string
    end
    
    #intersection of all courses in the city and the conditions that the course happens in a week and matches
    #search query
    
    @courses = (@all_courses_in_city & Course.find(:all, :conditions => ["(title OR description) LIKE ? AND date BETWEEN ? AND ?", search_string,date, date.advance(:weeks => 2)])).paginate(:page => params[:page], :per_page => 10)
    @top_suggestions =  Csuggestion.tally(
      {  :at_least => 1,
          :at_most => 10000,
          :limit => 10,
          :order => "csuggestions.name DESC"
      })
     # p @top_suggestions
      @random_course = Course.find(rand(Course.count-1) + 1)
      
     
  end
  

end
