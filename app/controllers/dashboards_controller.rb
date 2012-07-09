class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def index
    feed_query_items = feed_query_items_for_mission
    @feed, @can_paginate, @last_item_displayed_at = genericized_feed(feed_query_items, params)
    respond_to do |format|
      format.html
      format.js do
        render :template => 'index'
      end
    end
  end


  def show
    case params[:id].to_sym
    when :mission
      feed_query_items = feed_query_items_for_mission
    # when :friends
    #   feed_query_items_for_friends
    when :me
      feed_query_items = feed_query_items_for_me
    end

    @feed, @can_paginate, @last_item_displayed_at = genericized_feed(feed_query_items, params)
  end

private

  def feed_query_items_for_mission
    mission_ids      = current_user.missions.map(&:id)
    comments         = Comment.where(:mission_id => mission_ids).where(:parent_id => nil)
    courses          = Course.where(:mission_id => mission_ids)
    topics           = Topic.where(:mission_id => mission_ids)
    crewmanships     = Crewmanship.where(:mission_id => mission_ids)
    feed_query_items = [courses, comments, topics, crewmanships]
  end

  def feed_query_items_for_me
    missions         = current_user.missions
    joined_mission   = current_user.crewmanships.where(:role => "explorer")
    guided_mission   = current_user.crewmanships.where(:role => "guide")
    completed_mission= current_user.crewmanships.where(:role => "completed")
    comments         = current_user.comments
    courses_taught   = current_user.courses_taught
    courses_attended = current_user.courses_attended
    topics           = current_user.topics

    feed_query_items = [missions, 
                        joined_mission, 
                        guided_mission, 
                        completed_mission, 
                        comments, 
                        courses_taught, 
                        courses_attended, 
                        topics]
    feed_query_items
  end

  # def feed_query_items_for_friends
  # end

  def genericized_feed(feed_query_items, options = {})
    last_item_displayed_at = options[:last_item_displayed_at]
    per_page               = options[:per_page]||20
    per_page               = per_page.to_i

    feed = feed_query_items.map do |item_query| 
      if last_item_displayed_at.present?
        item_query = item_query.where("created_at < ?", DateTime.parse(last_item_displayed_at))
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