if Rails.env.production?
  PAYPAL_USERNAME   = "hello_api1.hourschool.com"
  PAYPAL_PASSWORD   = "Z6YYUCS2HEPNDSRM"
  PAYPAL_SIGNATURE  = "AFcWxV21C7fd0v3bYYYRCpSSRl31Ato1VoQ6l1a69Z20guz1MVuRyfnd"
else
  Paypal.sandbox!
  PAYPAL_USERNAME   = "hello_1334775580_biz_api1.hourschool.com"
  PAYPAL_PASSWORD   = "1334775605"
  PAYPAL_SIGNATURE  = "AeNWZgb4y6.aace1AvBvOXarNJiaAj2Siu.0bC5Dt5F-Q6Bwt7B-Lq6P"
end


PayPal::Recurring.configure do |config|
  config.sandbox    = true
  config.username   = PAYPAL_USERNAME
  config.password   = PAYPAL_PASSWORD
  config.signature  = PAYPAL_SIGNATURE
end