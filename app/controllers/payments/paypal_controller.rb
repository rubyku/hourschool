class Payments::PaypalController < ApplicationController


  def paypal
    if current_account == Account.find(4)
       Paypal::Express::Request.new(
        :username   => christina.mirando_api1.gmail.com,
        :password   => 3TRLAHE65P89ZFXG,
        :signature  => AHuWaRANd0mMqR6W2dFx.KCc0SaRAgHmt8JBU3ShwwNs1HxhwmX0p7XT
      )
    else 
       Paypal::Express::Request.new(
        :username   => PAYPAL_USERNAME,
        :password   => PAYPAL_PASSWORD,
        :signature  => PAYPAL_SIGNATURE
      )
    end
  end
  
  def request_for_course(course)
    Paypal::Payment::Request.new(
      :description   => course.title,
      :amount        => course.price,
    )
  end

end