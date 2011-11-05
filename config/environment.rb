# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
HourschoolV2::Application.initialize!

ActionMailer::Base.default_content_type = "text/html"