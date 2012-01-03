module User::Facebook
  extend ActiveSupport::Concern

  # facebook stores their states in full name ex. Texas not Tx
  def in_the_same_state_fb?(friend_hash)
    return false if friend_hash['location'].blank?
    friend_hash['location'].include? full_state
  end

  def not_in_the_same_state_fb?(friend_hash)
    !in_the_same_state_fb?(friend_hash)
  end

  def in_the_same_city_fb?(friend_hash)
    return false if friend_hash['location'].blank?
    friend_hash['location'].include?(city) && in_the_same_state_fb?(friend_hash)
  end


  def facebook?
    fb_token.present?
  end

  def fetch_facebook_permissions
    @facebook_permissions ||= cache(:expires_in => 24.hours).fetch_facebook_permissions
  end

  def facebook_permissions
    @facebook_permissions ||= facebook_graph.get_connections('me', 'permissions').first
  end

  def facebook_permissions_include?(perm)
    fetch_facebook_permissions[perm] == 1
  end

  def require_permission!(perm)
    raise "User does not have permission:#{perm}" unless facebook_permissions_include? perm
  end

  def facebook_graph
    @facebook_graph ||= Koala::Facebook::API.new(fb_token)
  end

  def raw_facebook_friends
    @raw_facebook_friends ||= facebook_graph.get_connections("me", "friends")
  end

  def facebook_friends
    @facebook_friends ||= cache(:expires_in => 12.hours).
                            raw_facebook_friends.
                            each_with_object([]) {|raw, collection|
                            collection << {'label'      => raw['name'],
                                           'id'         => raw['id'],
                                           'name'       => raw['name'],
                                           'image_url'  => "http://graph.facebook.com/#{raw['id']}/picture?type=square"
                                           }
                            }
  end

  def facebook_friend_ids
    @facebook_friend_ids ||= raw_facebook_friends.map {|user_hash| user_hash["id"] }
  end

  # :name is name of link
  # :link is url of link
  def facebook_wall_post(options = {})
    raise 'must provide message' if ( message = options.delete(:message) ).blank?
    raise 'must provide :id'     if ( id      = options.delete(:id)      ).blank?
    UserMailer.simple(:to => "richard@hourschool.com, ruby@hourschool.com", :subject => "someone invited a friend with facebook", :body => "User Number: #{self.id}").deliver
    facebook_graph.put_wall_post(message, options, id)
  end


  # Understand that these methods can take a long time to run
  # to minimize time spent running these always use fetch_
  # methods that will populate from the cache.
  #
  # Ideally these caches will be warmed in a background process
  #
  module ExpensiveMethods


    def warm_facebook_expensive_cache
      cache(:fetch, :expires_in => 12.hours).facebook_friend_locations
      cache(:fetch, :expires_in => 12.hours).facebook_friend_interests
      cache(:fetch, :expires_in => 12.hours).facebook_friend_likes
      cache(:fetch, :expires_in => 12.hours).facebook_friend_activities
      cache(:fetch, :expires_in => 12.hours).full_facebook_friends
      true
    end

    # zomg this takes a long time ~ 2 minutes for 1000 friends
    def force_refresh_facebook_expensive_cache
      cache(:write, :expires_in => 12.hours).facebook_friend_locations
      cache(:write, :expires_in => 12.hours).facebook_friend_interests
      cache(:write, :expires_in => 12.hours).facebook_friend_likes
      cache(:write, :expires_in => 12.hours).facebook_friend_activities
      cache(:write, :expires_in => 12.hours).full_facebook_friends
      true
    end

    def fetch_facebook_friend_locations
      @fetch_facebook_friend_locations  ||= cache(:expires_in => 12.hours).facebook_friend_locations
    end

    def fetch_facebook_friend_interests
      @fetch_facebook_friend_interests  ||= cache(:expires_in => 12.hours).facebook_friend_interests
    end

    def fetch_facebook_friend_likes
      @fetch_facebook_friend_likes      ||= cache(:expires_in => 12.hours).facebook_friend_likes
    end

    def fetch_facebook_friend_activities
      @fetch_facebook_friend_activities ||= cache(:expires_in => 12.hours).facebook_friend_activities
    end

    def fetch_full_facebook_friends
      @fetch_full_facebook_friends      ||= cache(:expires_in => 12.hours).full_facebook_friends
    end

    protected

    # automatically yields top a block all of your friends in groups of 50 and re-assembles the results
    def batch_facebook_request_on_friends
      result = []
      facebook_friends.in_groups_of(50, false) do |facebook_friends|
        result << facebook_graph.batch do |batch_api|
          facebook_friends.each do |friend|
            yield batch_api, friend
          end
        end
      end
      result.flatten(1)
    end


    # calls get_object on all of a user's friends
    def get_batch_friend_data(options = {})
      batch_facebook_request_on_friends do |batch_api, friend|
        batch_api.get_object(friend['id'], options)
      end
    end

    # calls get_connections on all of a user's friends for a give connection_name
    def get_batch_connections_for_friends(connection_name, options = {})
      batch_facebook_request_on_friends do |batch_api, friend|
        batch_api.get_connections(friend['id'], connection_name, options)
      end
    end

    def facebook_friend_locations
      get_batch_friend_data(:fields => 'location').map    {|element| element.blank? ? {} : element}
    end

    def facebook_friend_interests
      get_batch_connections_for_friends('interests').map  {|element| element.blank? ? [] : element}
    end

    def facebook_friend_activities
      get_batch_connections_for_friends('activities').map {|element| element.blank? ? [] : element}
    end

    def facebook_friend_likes
      get_batch_connections_for_friends('likes').map      {|element| element.blank? ? [] : element}
    end



    def full_facebook_friends
      @full_facebook_friends = []
      facebook_friends.each_with_index do |friend, index|
        hash = HashWithIndifferentAccess.new(name:friend['name'], id: friend['id'], image_url: friend['image_url'], label: friend['name'])
        # hash[:interests]   = fetch_facebook_friend_interests[index].map  {|x| x['name']}
        # hash[:activities]  = fetch_facebook_friend_activities[index].map {|x| x['name']}
        # hash[:likes]       = fetch_facebook_friend_likes[index].map      {|x| x['name']}
        hash[:location]    = fetch_facebook_friend_locations[index]['location']['name'] if fetch_facebook_friend_locations[index]['location'].present?
        @full_facebook_friends << hash
      end
      return @full_facebook_friends
    end
  end
  include ExpensiveMethods

  # User::FacebookFullWarm.new()
  class FullCacheWarm
    attr_accessor :user_id

    def initialize(user_id)
      self.user_id = user_id
    end


    def perform
      user = User.find(user_id)
      user.warm_facebook_expensive_cache
    end
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



end