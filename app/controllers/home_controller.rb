require 'will_paginate/array'
class HomeController < ApplicationController
  
  def index
    if current_user
      redirect_to current_user
    end
  end
  
  def learn
    
    if current_user
      @location = current_user.city
    else
      #default it
      @location = "Austin"
    end
    #if location is requested, assign that
    if !params[:location].nil?
      @location = params[:location]
    end
    #if first request, and no pagination exsits, save the location in session
    if params[:page].nil? 
      session[:location] = @location
    end
    
    #if not the first request
    if (params[:location].nil? || params[:location].blank?) && @location.nil? && !params[:page].nil?
      @location = session[:location]
    end
    date = Date.today
    
    city = City.find_by_name(@location)
    neighborhood_30 = City.geo_scope(:within => "30", :origin => [city.lat,city.lng])
    @classes_in_my_location = []
     @suggestions_in_my_location = []
    neighborhood_30.each do |ncity|
      @classes_in_my_location += City.find(:first, :conditions => ["name LIKE ? AND state LIKE ?", "#{ncity.name}", "#{ncity.state}"]).courses
      @suggestions_in_my_location += City.find(:first, :conditions => ["name LIKE ? AND state LIKE ?", "#{ncity.name}", "#{ncity.state}"]).csuggestions
    end
    
    #get classes this month
    @classes_this_week = Course.where('date BETWEEN ? AND ?', date, date.advance(:weeks => 4)).find(:all)
    @classes = (@classes_in_my_location & @classes_this_week).paginate(:page => params[:page], :per_page => 6)
    
    # @classes_this_week = @classes_this_week[0..9] unless @classes_this_week.size < 10
    @top_suggestions =  Csuggestion.tally(
      {  :at_least => 1,
          :at_most => 10000,
          :limit => 100,
          :order => "csuggestions.name DESC"
      })
      
      #top suggestions has to be the first operator to preserve ranking
      @suggestions = (@top_suggestions & @suggestions_in_my_location).paginate(:page => params[:page], :per_page => 3)
     # p @top_suggestions
      @random_course = Course.find(rand(Course.count-1) + 1)
      @classes_we_like = []
      (1..2).each do |val|
        @classes_we_like << Course.find(rand(Course.count-1) + 1)
      end
  end
  
  
  def teach
     if current_user
       @location = current_user.city
     else
       #default it
       @location = "Austin"
     end
     #if location is requested, assign that
     if !params[:location].nil?
       @location = params[:location]
     end
     #if first request, and no pagination exsits, save the location in session
     if params[:page].nil? 
       session[:location] = @location
     end

     #if not the first request
     if (params[:location].nil? || params[:location].blank?) && @location.nil? && !params[:page].nil?
       @location = session[:location]
     end
    
     city = City.find_by_name(@location)
      neighborhood_30 = City.geo_scope(:within => "30", :origin => [city.lat,city.lng])
      
       @suggestions_in_my_location = []
      neighborhood_30.each do |ncity|
        @suggestions_in_my_location += City.find(:first, :conditions => ["name LIKE ? AND state LIKE ?", "#{ncity.name}", "#{ncity.state}"]).csuggestions
      end
      
     @top_suggestions =  Csuggestion.tally(
        {  :at_least => 1,
            :at_most => 10000,
            :limit => 100,
            :order => "csuggestions.name DESC"
        })
       # p @top_suggestions
       @suggestions = (@top_suggestions & @suggestions_in_my_location).paginate(:page => params[:page], :per_page => 3)
       
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
    p params
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
    @courses_matching_query = Course.find(:all, :conditions => ["description LIKE ? AND date BETWEEN ? AND ?", search_string,date, date.advance(:weeks => 2)])
    
    p "search string is #{search_string}"
    @courses = (@all_courses_in_city & @courses_matching_query).paginate(:page => params[:page], :per_page => 10)
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
