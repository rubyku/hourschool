source 'http://rubygems.org'

ruby '2.0.0'

gem 'rails',                '3.2.13'

group :assets do
  gem 'coffee-rails',       '~> 3.2.1'
  gem 'uglifier',           '>= 1.0.3'
  gem 'sass-rails',         '~> 3.2.4'
end

gem 'dotenv-rails', :groups => [:development, :test]

gem 'sextant', :group => :development
gem 'quiet_assets', :group => :development


gem 'paypal-express'
gem "paypal-recurring"

gem 'ice_cube',             '~> 0.8.0'

gem 'sass-rails',           '~> 3.2.4'

gem 'pg',                   '~> 0.12.2'

gem 'thin'
gem 'unicorn',              '~> 4.2.0'

gem 'pg',                   '~> 0.12.2'

# cache helper
gem 'method_cacheable',     '0.0.4'
gem "dalli",                '~> 1.1.4' # for memcache

# User Authentication
gem 'devise',               '~> 1.4.9'

gem 'meta_search',          '>= 1.1.0.pre'

#gem "oa-oauth", :require => "omniauth/oauth"
gem "omniauth",             '~> 0.3.2'

# Social
#gem 'twitter',              '~> 2.0.2'
gem "koala",                '~> 1.2.1' # For Facebook
gem 'tumblr-api',           '~> 0.1.4'


# Error logging/reporting
gem 'newrelic_rpm',         '~> 3.6.5'
gem "airbrake",             '~> 3.0.9'

gem 'timezone',             '~> 0.1.4'

gem 'haml',                 '~> 3.1.4'
gem 'rake',                 '~> 0.9.2'
gem 'jquery-rails',         '>= 1.0.19'

gem 'friendly_id',          '4.0.9'

# gem 'mysql2',               '~> 0.2.6'

#tagging and voting
gem 'acts-as-taggable-on',  '~> 2.1.0'
gem 'thumbs_up',            '~> 0.4.6'

#pagination
gem 'will_paginate',        '~> 3.0.2'

#searching-indexing
gem 'sunspot_rails',        '~> 1.3.0'


# Delayed job
gem 'delayed_job',          '~> 2.1.4'

# rails-tinymce
# gem 'use_tinymce'

#uploads, parsing, etc
gem 'paperclip',            '~> 2.7.4'
gem 'aws-sdk',              '~> 1.2.6'

#storage
gem 'aws-s3',               '~> 0.6.2'


gem 'wicked',               '0.0.2'


gem 'geokit-rails3',        :git =>  'git://github.com/jlecour/geokit-rails3.git'

gem 'awesome_print'         # for the printing

gem 'rinku',              '~> 1.2.2', :require => 'rails_rinku'


gem 'cancan',             '~> 1.6.5'

# For the Sitemaps!
gem 'sitemap_generator',  '~> 3.0.0'
gem 'carrierwave',        '~> 0.5.8'
gem 'fog',                '~> 1.1.2'


gem "stripe", "~> 1.6.3"

gem 'mail_view',          '~> 1.0.2'


group :development, :test do

  gem 'database_cleaner'
  gem 'vcr' # for replaying web requests with stripe
  gem 'poltergeist',       '~> 1.0.2'
  gem 'git_test'

  # For Database data transfer
  gem 'taps',               '~> 0.3.23'


  gem 'sunspot_solr',       '~> 1.3.0'       # pre-packaged Solr distribution for use in development
  gem 'capybara',           '~> 1.1.2'
  gem "rspec-rails",        "~> 2.8.1"
  gem 'factory_girl_rails', '~> 1.4.0'
  gem 'rb-fsevent',         '~> 0.9.3'
  gem "selenium-webdriver", "~> 2.24.0"

  # Guard
  gem 'guard-livereload',   '~> 0.4.0'
  gem 'guard-rspec',        '~> 0.6.0'
  gem 'guard-spork',        '~> 0.5.1'
  gem 'guard-bundler',      '~> 0.1.3'
  gem 'guard-sass',         '~> 0.5.4'


  gem 'foreman'
  gem 'forgery',            '~> 0.5.0'
  gem 'launchy',            '~> 2.0.5'
  gem 'random_data',        '~> 1.5.2'
  gem 'faker',              '~> 1.0.1'
  gem 'ffaker',             '~> 1.12.1'
  gem 'timecop',            '~> 0.3.5'
  gem 'spork',              '~> 0.8.5'


  # Debugging
  # gem 'linecache19', '~> 0.5.13'
  # gem 'ruby-debug19', :require => 'ruby-debug'

  gem 'progress_bar'
end

group :test do
  gem 'webmock', :require => false
end
