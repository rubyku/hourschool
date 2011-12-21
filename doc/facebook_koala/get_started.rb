# SELECT name FROM user WHERE uid = me()
# SELECT name, likes from user WHER uid in '122611663'
your_oauth_token = User.rs.fb_token
@graph = Koala::Facebook::API.new(your_oauth_token) # 1.2beta and beyond


friends = @graph.get_connections("me", "friends")
friend_ids = friends.map {|friend| friend['id'] }


Benchmark.measure do
  locations = {}
  threads = []
  friend_ids.first(100).each do |friend_id|
      friend = @graph.get_object(friend_id)
      puts "=========="
      puts friend_id
      puts friend['location']['name'] if friend['location'].present? && friend['location'].present?
      # (@locations[friend['location']['name']] ||= []) << friend['id'] if friend['location'].present? && friend['location'].present?
  end
end.real



likes = @graph.get_connections("me", "likes")
# me = @graph.get_object("me")



# This will actually post to Ruby's wall
@graph.put_wall_post("I really think you should take this class with me", {:name => "Beginner Bread Making for Ceramic Chinese Food", :link => "http://hourschool.com"}, "122611663")