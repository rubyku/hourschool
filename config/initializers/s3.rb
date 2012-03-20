# initializers/s3.rb
if Rails.env == "production"
  # set credentials from ENV hash
  S3_CREDENTIALS = { :access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET'], :bucket => "hourschool-prod"}
elsif Rails.env.staging?
	S3_CREDENTIALS = { :access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET'], :bucket => "hourschool-staging"}
else
  # get credentials from YML file
  s3_config_dir  = Rails.root.join("config/s3.yml").to_s
  S3_CREDENTIALS = YAML.load_file(s3_config_dir)[Rails.env].to_options
end