# config/initializers/carrierwave.rb

puts S3_CREDENTIALS.inspect

CarrierWave.configure do |config|
  config.cache_dir       = "#{Rails.root}/tmp/"
  config.storage         = :fog
  config.permissions     = 0666
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => S3_CREDENTIALS[:access_key_id],
    :aws_secret_access_key  => S3_CREDENTIALS[:secret_access_key],
  }
  config.fog_directory  = 'hourschool-sitemap'
end