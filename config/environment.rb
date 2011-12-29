# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
HourschoolV2::Application.initialize!

ActionMailer::Base.default_content_type = "text/html"

Twitter.configure do |config|
  config.consumer_key       = "k3BLACUuU7nRV6swgXZ6jw"
  config.consumer_secret    = "blcQ4no16A11KYYRV4azhIQDyxPwPPdW3SMRdpLMI"
  config.oauth_token        = "443154937-ZZc5SD1L1vAa9Fv2sUBdz0DMSyQcESrWUvKYsghA"
  config.oauth_token_secret = "8srkNpTyzMUsdizvJ6eU2qTqv0z5n9nHjvORYOKCx7E"
end
