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
    friend_hash['location'].include?(city.try(:name)) && in_the_same_state_fb?(friend_hash)
  end

  def no_facebook?
    !facebook?
  end

  def facebook?
    fb_token.present?
  end

  def needs_facebook_reconnect?(permissions)
    return true if no_facebook?
    facebook_permissions_mismatch? permissions
  end

  def fetch_facebook_permissions
    @facebook_permissions ||= cache(:expires_in => 24.hours).facebook_permissions
  end

  def facebook_permissions
    @facebook_permissions ||= facebook_graph.get_connections('me', 'permissions').first
  end

  def facebook_permissions_include?(perm)
    fetch_facebook_permissions[perm] == 1
  end

  def facebook_permissions_mismatch?(permissions)
    raise "expecting array got #{permissions.class}" unless permissions.is_a? Array
    permissions.map {|perm| facebook_permissions_include? perm }.include? false
  end

  def facebook_permissions_match?(permissions)
    !facebook_permissions_mismatch?(permissions)
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
    DefaultExpires = 36.hours

    def warm_facebook_expensive_cache
      cache(:fetch, :expires_in => DefaultExpires).facebook_friend_locations
      cache(:fetch, :expires_in => DefaultExpires).facebook_friend_interests
      cache(:fetch, :expires_in => DefaultExpires).facebook_friend_likes
      cache(:fetch, :expires_in => DefaultExpires).facebook_friend_activities
      #full_facebook_friends
      true
    end

    # zomg this takes a long time ~ 2 minutes for 1000 friends
    def force_refresh_facebook_expensive_cache
      cache(:write, :expires_in => DefaultExpires).facebook_friend_locations
      cache(:write, :expires_in => DefaultExpires).facebook_friend_interests
      cache(:write, :expires_in => DefaultExpires).facebook_friend_likes
      cache(:write, :expires_in => DefaultExpires).facebook_friend_activities
      #full_facebook_friends
      true
    end

    def read_facebook_friend_locations
      @read_facebook_friend_locations  ||= cache(:read).facebook_friend_locations
      @read_facebook_friend_locations  ||= []
    end

    def read_facebook_friend_interests
      @read_facebook_friend_interests  ||= cache(:read).facebook_friend_interests
      @read_facebook_friend_interests  ||= []
    end

    def read_facebook_friend_likes
      @read_facebook_friend_likes      ||= cache(:read).facebook_friend_likes
      @read_facebook_friend_likes      ||= []
    end

    def read_facebook_friend_activities
      @read_facebook_friend_activities ||=  cache(:read).facebook_friend_activities
      @read_facebook_friend_activities ||= []
    end


    def fetch_facebook_friend_locations
      @fetch_facebook_friend_locations  ||= cache(:expires_in => DefaultExpires).facebook_friend_locations
    end


    def fetch_facebook_friend_interests
      @fetch_facebook_friend_interests  ||= cache(:expires_in => DefaultExpires).facebook_friend_interests
    end

    def fetch_facebook_friend_likes
      @fetch_facebook_friend_likes      ||= cache(:expires_in => DefaultExpires).facebook_friend_likes
    end

    def fetch_facebook_friend_activities
      @fetch_facebook_friend_activities ||= cache(:expires_in => DefaultExpires).facebook_friend_activities
    end

    def fetch_full_facebook_friends
      @fetch_full_facebook_friends      ||= full_facebook_friends
    end

    # full_facebook_friends method should always be quickish since it relies on other cached methods
    # however it cannot be cashed itself since it is too big to fit into memcache
    def full_facebook_friends
      @full_facebook_friends = []
      facebook_friends.each_with_index do |friend, index|
        hash = HashWithIndifferentAccess.new(name: friend['name'], id: friend['id'], image_url: friend['image_url'], label: friend['name'])
        hash[:interests]   = read_facebook_friend_interests[index]  ||[]
        hash[:activities]  = read_facebook_friend_activities[index] ||[]
        hash[:likes]       = read_facebook_friend_likes[index]      ||[]
        hash[:location]    = read_facebook_friend_locations[index]  ||""
        @full_facebook_friends << hash
      end
      return @full_facebook_friends
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
      friend_data = get_batch_friend_data(:fields => 'location').map {|element| element.blank? ? {} : element}
      friend_data.map {|friend| friend['location'].try(:[], 'name')||"" }
    end

    def facebook_friend_interests
      fb_interests = get_batch_connections_for_friends('interests').map {|element| element.blank? ? [] : element}
      fb_interests.map {|interests| interests.map {|interest| interest['name']}}
    end

    def facebook_friend_activities
      fb_activities = get_batch_connections_for_friends('activities').map {|element| element.blank? ? [] : element}
      fb_activities.map {|activities| activities.map {|activity| activity['name']}}
    end

    def facebook_friend_likes
      fb_likes = get_batch_connections_for_friends('likes').map {|element| element.blank? ? [] : element}
      fb_likes.map {|likes| likes.map {|like| like['name']}}
    end

  end
  include ExpensiveMethods

  # Delayed::Job.enqueue User::Facebook::FullCacheWarm.new(User.rs.id)
  # rake jobs:work
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