
https://github.com/nov/paypal-express/wiki/Instant-Payment

## Request

To create a new paypal request go to localhost:3000/payments/paypal/requests/new

Click on the button, you should be redirected to paypal and asked to log in.



## Test accounts


You can use make a new test account by going to https://developer.paypal.com


Then change the credentials in config/paypal.rb

### Or

You can use my test user richar_1334798373_per@heroku.com

with password: 334798373


## Response

Paypal will return a response back to the payments/paypal/response controller and hit the create action.



## TODO

You need to sign up for an authenticated account with paypal, add the credentials to the config/initializers/paypal.rb (inside of the production case).


Add the pay with paypal button anywhere you like (copy from payments/paypal/requests/new.html)


Deploy


Test

Smile :)