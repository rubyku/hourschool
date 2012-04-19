if Rails.env.production?

else
  Paypal.sandbox!
  PAYPAL_USERNAME   = "richar_1334798699_biz_api1.heroku.com"
  PAYPAL_PASSWORD   = "1334798723"
  PAYPAL_SIGNATURE  = "AL0M4ALm2V5nIrWDqJdRfE8TCsK5A36Aq.CUapE2nUVD1Qj2i.yNZJWd"
end


PayPal::Recurring.configure do |config|
  config.sandbox    = true
  config.username   = PAYPAL_USERNAME
  config.password   = PAYPAL_PASSWORD
  config.signature  = PAYPAL_SIGNATURE
end