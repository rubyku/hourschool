module ApplicationHelper

  def count_in_place_sentence(array)
    array.inject(Hash.new(0)) {|h,i| h[i] += 1; h }.map {|city, count| "#{count} in #{city}"}.to_sentence
  end

  def get_user_name(id)
    User.find(id).name
  end
  
  def get_tumblr_first_regular_post
    #fetch all text posts
    Tumblr.blog = 'hourschool'
    @tumbles = Tumblr::Post.all(:filter => :text)
    @tumbles.each do |tum|
      #find the first one that has a regular_title and regular_text
      if tum["type"] == "regular"
        return tum
      end
    end
    nil
  end
  
  def get_tumblr_first_three_regular_dashboard_post
     #fetch all text posts
     Tumblr.blog = 'hourschool-dashboard'
     @tums = []
     count = 0
     @tumbles = Tumblr::Post.all(:filter => :text)
     @tumbles.each do |tum|
       #find the first one that has a regular_title and regular_text
       if tum["type"] == "regular"
         @tums << tum
         count += 1 unless count == 3
         if count == 3 
           return @tums
         end
       end
     end
     return @tums
   end
   
   def user_admin?
     #bad way to do this..Should be added to admin field in db. later.
     email = current_user.email
     email == "saranyan@hourschool.com" || email == "ruby@hourschool.com" || email == "alex@hourschool.com" || email == "saranyan13@gmail.com"
   end
end
