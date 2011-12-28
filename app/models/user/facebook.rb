module User::Facebook
  extend ActiveSupport::Concern

  def facebook?
    fb_token.present?
  end

  def facebook_permissions
    @facebook_permissions ||= facebook_graph.get_connections('me', 'permissions').first
  end

  def facebook_permissions_include?(perm)
    facebook_permissions[perm] == 1
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
    cache(:expires_in => 12.hours).
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

    def fetch_facebook_friend_locations
      cache(:expires_in => 12.hours).facebook_friend_locations
    end

    def fetch_facebook_friend_interests
      cache(:expires_in => 12.hours).facebook_friend_interests
    end

    def fetch_facebook_friend_likes
      cache(:expires_in => 12.hours).facebook_friend_likes
    end

    def fetch_facebook_friend_activities
      cache(:expires_in => 12.hours).facebook_friend_activities
    end

    protected
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

    def _get_batch_friend_data(options = {})
      batch_facebook_request_on_friends do |batch_api, friend|
        batch_api.get_object(friend['id'], options)
      end
    end

    def _get_batch_connections_for_friends(connection_name, options = {})
      batch_facebook_request_on_friends do |batch_api, friend|
        batch_api.get_connections(friend['id'], connection_name, options)
      end
    end

    def facebook_friend_locations
      _get_batch_friend_data(:fields => 'location')
    end

    def facebook_friend_interests
      _get_batch_connections_for_friends('interests')
    end

    def facebook_friend_activities
      _get_batch_connections_for_friends('activities')
    end

    def facebook_friend_likes
      _get_batch_connections_for_friends('likes')
    end
  end
  include ExpensiveMethods

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