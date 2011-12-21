module User::Facebook
  extend ActiveSupport::Concern

  def facebook?
    fb_token.present?
  end

  def facebook_graph
    @facebook_graph ||= Koala::Facebook::API.new(fb_token)
  end

  def raw_facebook_friends
    @raw_facebook_friends ||= facebook_graph.get_connections("me", "friends")
  end

  def facebook_friend_ids
    @facebook_friend_ids ||= raw_facebook_friends.map {|user_hash| user_hash["id"] }
  end

  def fetch_facebook_friend_ids
    cache(:fetch, :expires_in => 12.hours).facebook_friend_ids
  end

  def get_interests_for_friends
    fetch_facebook_friend_ids.each do |facebook_id|
      facebook_graph.get_connections(friend_id, "likes")
    end
  end

  # :name is name of link
  # :link is url of link
  def facebook_wall_post(options = {})
    raise 'must provide message' if ( message = options.delete(:message) ).blank?
    raise 'must provide :id'     if ( id      = options.delete(:id)      ).blank?
    UserMailer.simple(:to => "richard@hourschool.com, ruby@hourschool.com", :subject => "someone invited a friend with facebook", :body => self.id).deliver
    facebook_graph.put_wall_post(message, options, id)
  end

  #### Likes
  # [{"name"=>"IndieGoGo.com",
  # "category"=>"Business/economy",
  #  "id"=>"7312612866",
  #  "created_time"=>"2011-11-23T14:57:27+0000"}]

  #### Activities
  # {"name"=>"Rock climbing",
  #  "category"=>"Sport",
  #  "id"=>"107455672610208",
  #  "created_time"=>"2011-04-28T05:39:13+0000"}


  module ClassMethods

  end
end