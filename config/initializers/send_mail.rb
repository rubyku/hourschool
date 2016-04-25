ActionMailer::Base.smtp_settings = {

  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "hourschool.com",
  :user_name            => "hello@hourschool.com",
  :password             => ENV['EMAIL_PASSWORD'],
  :authentication       => "plain"
  # :tls => true,
  #   :enable_starttls_auto => true,
}
