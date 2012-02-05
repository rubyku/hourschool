require 'spec_helper'
require 'capybara/rspec'

Capybara.default_host = "http://example.com"

RSpec.configure do |config|
  config.after(:each) { Warden.test_reset! }
end