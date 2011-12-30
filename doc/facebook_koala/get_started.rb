# SELECT name FROM user WHERE uid = me()
# SELECT name, likes from user WHER uid in '122611663'
your_oauth_token = User.rs.fb_token
@graph = Koala::Facebook::API.new(your_oauth_token) # 1.2beta and beyond


friends = @graph.get_connections("me", "friends")
friend_ids = friends.map {|friend| friend['id'] }


# Benchmark.measure do
#   locations = {}
#   threads = []
#   friend_ids.first(100).each do |friend_id|
#       friend = @graph.get_object(friend_id)
#       puts "=========="
#       puts friend_id
#       puts friend['location']['name'] if friend['location'].present? && friend['location'].present?
#       # (@locations[friend['location']['name']] ||= []) << friend['id'] if friend['location'].present? && friend['location'].present?
#   end
# end.real
#


likes = @graph.get_connections("me", "likes")
# me = @graph.get_object("me")

user = User.rs
facebook_friends = user.cache.facebook_friends
mass_facebook_data_key = "users:#{user.id}:mass_facebook_data"



timing = Benchmark.measure do

  Rails.cache.write(mass_facebook_data_key, nil)


    friend_likes = []
    facebook_friends.in_groups_of(50, false) do |facebook_friends|
      friend_likes << user.facebook_graph.batch do |batch_api|
        facebook_friends.each do |friend|
          batch_api.get_connections(friend['id'], "likes")
        end
      end
    end
    friend_likes.flatten!(1)

  timing = Benchmark.measure do
    friend_interests = []
    facebook_friends.in_groups_of(50, false) do |facebook_friends|
      friend_interests << user.facebook_graph.batch do |batch_api|
        facebook_friends.each do |friend|
          batch_api.get_connections(friend['id'], "interests")
        end
      end
    end
    friend_interests.flatten!(1)
  end

  timing = Benchmark.measure do
    friend_location = []
    facebook_friends.in_groups_of(50, false) do |facebook_friends|
      friend_location << user.facebook_graph.batch do |batch_api|
        facebook_friends.each do |friend|
          batch_api.get_object(friend['id'], :fields => 'location')
        end
      end
    end
    friend_location.flatten!(1)
  end



    # get from cache
    mass_facebook_data = []
    facebook_friends.each_with_index do |friend, index|
      name      = friend['name']
      id        = friend['id']
      interests = friend_interests[index].map {|x| x['name']}
      likes     = friend_likes[index].map {|x| x['name']}
      location  = friend_location
      mass_facebook_data << HashWithIndifferentAccess.new(name: name, id: id, interests: interests, likes: likes, location: location)
    end

    # set in cache
    Rails.cache.write(mass_facebook_data_key, mass_facebook_data)
    # Rails.cache.read(mass_facebook_data_key)
  end
end


# This will actually post to Ruby's wall
@graph.put_wall_post("I really think you should take this class with me", {:name => "Beginner Bread Making for Ceramic Chinese Food", :link => "http://hourschool.com"}, "122611663")