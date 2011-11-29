require 'will_paginate/array'
class HomeController < ApplicationController
  layout nil
    layout 'application', :except => :index
    before_filter :authenticate_user!, :only => [:nominate, :nominate_send]
  def index
    if current_user
      redirect_to user_root_path
      #redirect_to current_user
    end
    # @fav1 = Course.find(5)
    # @fav2 = Course.find(3)
    # @fav3 = Course.find(4)
    # @fav4 = Course.find(6)
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
    neighborhood_30 = []
    if !city.nil?
      neighborhood_30 = City.geo_scope(:within => "30", :origin => [city.lat,city.lng])
    end

    @classes_in_my_location = []
     @suggestions_in_my_location = []
     if neighborhood_30.size == 0
       @classes_in_my_location += City.find(:first, :conditions => ["name LIKE ? ", "#{city.name}"]).courses unless city.nil?
       @suggestions_in_my_location += City.find(:first, :conditions => ["name LIKE ?", "#{city.name}"]).csuggestions unless city.nil?
     end
    neighborhood_30.each do |ncity|
      @classes_in_my_location += City.find(:first, :conditions => ["name LIKE ? AND state LIKE ?", "#{ncity.name}", "#{ncity.state}"]).courses
      @suggestions_in_my_location += City.find(:first, :conditions => ["name LIKE ? AND state LIKE ?", "#{ncity.name}", "#{ncity.state}"]).csuggestions
    end

    #get classes this month
    @classes_this_week = Course.where('date BETWEEN ? AND ?', date, date.advance(:weeks => 4)).find(:all, :order => "courses.date ASC")
    @classes = (@classes_in_my_location & @classes_this_week).paginate(:page => params[:page], :per_page => 9)
    #p @classes_in_my_location
    # @classes_this_week = @classes_this_week[0..9] unless @classes_this_week.size < 10
    @top_suggestions =  Csuggestion.tally(
      {  :at_least => 1,
          :at_most => 10000,
          :limit => 100,
          :order => "csuggestions.name DESC"
      })

      #top suggestions has to be the first operator to preserve ranking
      @suggestions = (@top_suggestions & @suggestions_in_my_location).paginate(:page => params[:page], :per_page => 3)
      p "ts"
      p @top_suggestions
      p @suggestions_in_my_location
     if Course.count > 0

        @random_course = Course.find(Integer(rand(Course.count-1)) + 1)
        @classes_we_like = []
        (1..2).each do |val|
          @classes_we_like << Course.find(Integer(rand(Course.count-1)) + 1)
        end
      else
        @classes_we_like = []

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
     neighborhood_30 = []
     if !city.nil?
       neighborhood_30 = City.geo_scope(:within => "30", :origin => [city.lat,city.lng])
     end

       @suggestions_in_my_location = []
        if neighborhood_30.size == 0
          @suggestions_in_my_location += City.find(:first, :conditions => ["name LIKE ?", "#{city.name}"]).csuggestions unless city.nil?
        end
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
       if Course.count > 0
          @random_course = Course.find(Integer(rand(Course.count-1)) + 1)
          @classes_we_like = []
          (1..2).each do |val|
            @classes_we_like << Course.find(Integer(rand(Course.count-1)) + 1)
          end
        else
          @classes_we_like = []
        end
  end

  def nominate
    @req = Csuggestion.find(params["id"])
  end

  def nominate_send
    UserMailer.send_nominate_mail_to_teacher(params[:email],current_user,params[:reqid],params[:message]).deliver
    @csuggestion = Csuggestion.find(params[:id])
    redirect_to @csuggestion
  end

  def nominate_confirm
    # @req = Csuggestion.find(params["id"])
  end

  def search_by_city
    date = Date.today
    @classes_this_week = City.find(:first, :conditions => ["name LIKE ?",params[:city] ]).courses.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 4)).find(:all).paginate(:page => params[:page], :per_page => 9)
    p @classes_this_week

  end

  def search_by_tg
    keyword =  TAGS[params[:index].to_i]
    #results = TBACKUP.search "tags:#{keyword}", {:fetch => 'cid'}
    date = Date.today
    #find classes tagged with that

      if session[:user_location].nil? || session[:user_location].blank?
        user_location = "Austin"
      else
        user_location = session[:user_location]
      end

      #@classes_this_week = City.find(:first, :conditions => ["name LIKE ?", "#{user_location}"]).courses.find(:all,:conditions => ['date between ? and ?', date, date.advance(:weeks => 4)]).tagged_with("#{keyword}").find(:all).paginate(:page => params[:page], :per_page => 6)

    @classes_this_week = Course.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 4)).tagged_with("#{keyword}").find(:all).paginate(:page => params[:page], :per_page => 9)
     @classes_we_like = []
      (1..2).each do |val|
        @classes_we_like << Course.find(Integer(rand(Course.count-1)) + 1)
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

  def about
  end

  def contactus
  end

  def search

    if Course.count > 0
      #default location is austin, if i don't find a location in my session_variable
      date = Date.today
      if session[:user_location].nil? || session[:user_location].blank?
        user_location = "Austin"
      else
        user_location = session[:user_location]
      end

      @all_courses_in_city = City.find(:first, :conditions => ["name LIKE ?", "#{user_location}"]).courses.find(:all,:conditions => ['date between ? and ?', date, date.advance(:weeks => 4)])

      #the sql query description like "%string%" will return a list of all courses
      #let us return everything and then filter it by city
      if Rails.env == "production"
        search_string = params[:search]
      else

        search_string = "%#{params[:search]}%"
      end
      if search_string.nil? || search_string.blank?
        search_string = session[:search_string]
      end
      if params[:page].nil?
        session[:search_string] = search_string
      end

      #intersection of all courses in the city and the conditions that the course happens in a week and matches
      #search query
      if Rails.env == "production"
        #user texticle in production for postgre search
        @courses_matching_query = Course.search(search_string)
      else
        @courses_matching_query = Course.find(:all, :conditions => ["(title LIKE ? OR description LIKE ?) AND date BETWEEN ? AND ?",search_string, search_string,date, date.advance(:weeks => 4)])
      end
      p "search string is #{search_string}"
      @courses = (@all_courses_in_city & @courses_matching_query).paginate(:page => params[:page], :per_page => 10)
      @top_suggestions =  Csuggestion.tally(
        {  :at_least => 1,
            :at_most => 10000,
            :limit => 10,
            :order => "csuggestions.name DESC"
        })
       # p @top_suggestions
        @random_course = Course.find(Integer(rand(Course.count-1)) + 1)
    else
      redirect_to root_path
    end

  end

  def about_save
    if !params[:about].nil?
      current_user.update_attribute :about, params[:about]
    end
    redirect_to current_user
  end

end
