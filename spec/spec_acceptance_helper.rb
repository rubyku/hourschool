require 'spec_helper'
require 'capybara/rspec'


RSpec.configure do |config|
  config.after(:each) { Warden.test_reset! }
end