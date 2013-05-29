class DashboardsController < ApplicationController
  before_filter :authenticate_user!, :only => [:show]

  def index
    feed_query_items = feed_query_items_for_mission
    @feed_items, @can_paginate, @last_item_displayed_at = genericized_feed(feed_query_items, params)
    @user = User.me_or_find(params[:id], current_user)

    if @feed_items.blank?
      feed_query_items = staff_picks_feed
      @staff_feed = true
      @feed_items, @can_paginate, @last_item_displayed_at = genericized_feed(feed_query_items, params)
    end
  end


  def show
    case params[:id].to_sym
    when :mission
      feed_query_items = feed_query_items_for_mission
      @user = current_user

    # when :friends
    #   feed_query_items_for_friends
    when :me
      @user            = User.me_or_find(params[:id], current_user)
      feed_query_items = feed_query_items_for_me
      @comment         = current_user.comments.new(params[:comment])
    end

    @compact_feed_items, @can_paginate, @last_item_displayed_at = genericized_feed(feed_query_items, params)

  end

private

  def staff_picks_feed
    mission_ids      = Mission.where(:featured => true).map(&:id) + [-1]
    comments         = Comment.where(:mission_id => mission_ids).where(:parent_id => nil)
    courses          = Course.where(:mission_id => mission_ids)
    topics           = Topic.where(:mission_id => mission_ids)
    crewmanships     = Crewmanship.where(:mission_id => mission_ids)
    feed_query_items = [courses, comments, topics, crewmanships]
  end

  def feed_query_items_for_mission
    mission_ids = current_user.missions.where(:status => "live").map(&:id) + [-1]
    [
      Comment.where(:mission_id => mission_ids).where(:parent_id => nil),
      Course.where(:mission_id => mission_ids),
      Topic.where(:mission_id => mission_ids),
      Crewmanship.where(:mission_id => mission_ids)
    ]
  end

  # show only items that stem from a live mission
  def feed_query_items_for_me
    feed_items =[
      @user.crewmanships.where(:role => "creator").joins(:mission).where(:missions => {:status => 'live'}),
      @user.crewmanships.where(:role => "explorer").joins(:mission).where(:missions => {:status => 'live'}),
      @user.crewmanships.where(:role => "guide").joins(:mission).where(:missions => {:status => 'live'}),
      @user.crewmanships.where(:role => "completed").joins(:mission).where(:missions => {:status => 'live'}),

      # comments can belong to course or a mission, make sure they are live before fetching them
      @user.comments.where(:course_id => nil).joins(:mission).where(:missions => {:status => 'live'}),
      @user.comments.where("course_id is not null").joins(:course).where(:courses => {:status => 'live'}),

      # courses can be live or be part of a mission that is live
      @user.courses_taught.joins(:mission).where(:missions => {:status => 'live'}).where(:status => 'live'),
      @user.courses_taught.where(:mission_id => nil).where(:status => 'live'),


      # courses can be live or be part of a mission that is live
      @user.courses_attended.joins(:mission).where(:missions => {:status => 'live'}).where(:status => 'live'),
      @user.courses_attended.where(:mission_id => nil).where(:status => 'live'),

      @user.topics.joins(:mission).where(:missions => {:status => 'live'})
    ]
  end

  # def feed_query_items_for_friends
  # end

  def genericized_feed(feed_query_items, options = {})
    last_item_displayed_at = options[:last_item_displayed_at]
    per_page               = options[:per_page]||20
    per_page               = per_page.to_i

    feed = feed_query_items.map do |item_query|
      if last_item_displayed_at.present?
        item_query = item_query.where("#{item_query.table.name}.created_at < ?", DateTime.parse(last_item_displayed_at))
      end

      item_query = item_query.order("created_at DESC")
      item_query = item_query.limit(per_page)
      item_query.all
    end.flatten.compact


    total_feed = feed.sort {|feed_item, feed_item_next| feed_item_next.created_at <=> feed_item.created_at}

    can_paginate            = total_feed.count > per_page
    feed                    = total_feed.first(per_page)
    last_item_displayed_at  = feed.last.try(:created_at)

    return feed, can_paginate, last_item_displayed_at
  end

end