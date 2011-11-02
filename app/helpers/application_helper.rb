module ApplicationHelper
  
  def get_user_name(id)
    User.find(id).name
  end
  
  def get_tumblr_first_regular_post
    #fetch all text posts
    @tumbles = Tumblr::Post.all(:filter => :text)
    @tumbles.each do |tum|
      #find the first one that has a regular_title and regular_text
      if tum["type"] == "regular"
        return tum
      end
    end
    nil
  end
end
