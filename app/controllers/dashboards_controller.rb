class DashboardsController < ApplicationController
  before_filter :authenticate_user!

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

    if @compact_feed_items.blank?
      @staff_feed = true
      feed_query_items = staff_picks_feed
      @compact_feed_items, @can_paginate, @last_item_displayed_at = genericized_feed(feed_query_items, params)
    end
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

  def feed_query_items_for_me
    [
      @user.crewmanships.where(:role => "creator"),
      @user.crewmanships.where(:role => "explorer"),
      @user.crewmanships.where(:role => "guide"),
      @user.crewmanships.where(:role => "completed"),
      @user.comments,
      @user.courses_taught,
      @user.courses_attended,
      @user.topics
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