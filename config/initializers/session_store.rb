# Be sure to restart your server when you modify this file.

# HourschoolV2::Application.config.session_store :cookie_store, :key => '_hourschool_v2_session', :domain => ".turunga.org"
# 
# if Rails.env == "development"
#   HourschoolV2::Application.config.session_store :cookie_store, :key => '_hourschool_v2_session', :domain => ".lvh.me"
# end
HourschoolV2::Application.config.session_store :cookie_store, :key => '_hourschool_v2_session', :domain => :all

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# HourschoolV2::Application.config.session_store :active_record_store
