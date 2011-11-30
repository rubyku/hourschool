require 'tumblr'

begin
  TUMUSER = Tumblr::User.new('hello@hourschool.com', 'ac4dlove')
rescue => ex
  Rails.logger.error ex.message
  Rails.logger.error("TUMBLR: could not Reach Tumblr")
end