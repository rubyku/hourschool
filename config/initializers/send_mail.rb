ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "hourschool.com",
  :user_name            => "hello@hourschool.com",
  :password             => "ac4dlove",
  :authentication       => "plain"
  #:enable_starttls_auto => true
}
