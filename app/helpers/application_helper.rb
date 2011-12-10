module ApplicationHelper

  module ExceptionHelpers
    def pretty_backtrace(exception)
      bc = ActiveSupport::BacktraceCleaner.new
      bc.add_filter { |line| line.gsub(Rails.root.to_s, '') }
      bc.add_filter { |line| line.gsub("\n", '<br/>') }
      clean_backtrace = bc.clean(exception.backtrace)
      clean_backtrace.join('<br />').html_safe
    end
  end
  include ExceptionHelpers


  module LayoutHelpers
    def id_for_body(body_id=nil)
      !body_id.blank? ? body_id : sanitized_controller_path.sub('/', '-') + '-' + action_name
    end

    def sanitized_controller_path
      controller_path
    end

    def classes_for_body(*body_classes)
      body_classes << sanitized_controller_path.split('/').first
      body_classes << sanitized_controller_path.sub('/', '-') if sanitized_controller_path.match('/')
      body_classes << action_name
      body_classes.join(' ')
    end

    def id_for_body(body_id=nil)
      !body_id.blank? ? body_id : sanitized_controller_path.sub('/', '-') + '-' + action_name
    end
  end

  include LayoutHelpers


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
