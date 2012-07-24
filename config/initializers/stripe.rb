if Rails.env.production?
  Stripe.api_key = "UDiRr9vd3KnchjRPqp9ox7FOpOSyA4US"
else
  Stripe.api_key = "08YRJcknyvtlMDhneFawvZ8a3JWveCaW"
end