class Payments::PaypalController < ApplicationController


  def paypal
     Paypal::Express::Request.new(
      :username   => PAYPAL_USERNAME,
      :password   => PAYPAL_PASSWORD,
      :signature  => PAYPAL_SIGNATURE
    )
  end
  
  def request_for_course(course)
    Paypal::Payment::Request.new(
      :description   => course.description,
      :amount        => course.price,
    )
  end

end