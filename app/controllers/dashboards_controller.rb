class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def index
    per_page               = params[:per_page]||20
    last_item_displayed_at = params[:last_item_displayed_at]

    mission_ids  = current_user.missions.map(&:id)
    comments     = Comment.where(:mission_id => mission_ids)
    courses      = Course.where(:mission_id => mission_ids)
    topics       = Topic.where(:mission_id => mission_ids)
    crewmanships = Crewmanship.where(:mission_id => mission_ids)

    feed_query_items = [courses, comments, topics, crewmanships]

    feed = feed_query_items.map do |item_query| 
      if last_item_displayed_at.present?
        item_query = item_query.where("created_at < ?", DateTime.parse(last_item_displayed_at))
      end

      item_query = item_query.order("created_at DESC")
      item_query = item_query.limit(per_page)
      item_query.all
    end.flatten.compact

    total_feed = feed.sort {|feed_item, feed_item_next| feed_item_next.created_at <=> feed_item.created_at}

    @can_paginate     = total_feed.count > per_page
    @feed             = total_feed.first(per_page)
    @last_item_displayed_at  = @feed.last.created_at
  end



end