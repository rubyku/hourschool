# This controller creates the PayPal Request
# if successful, the user will be redirected back to
# the paypal response


# Note: that `paypal` and `request_for_course` are in paypal_controller.rb


class Payments::Paypal::RequestsController < Payments::PaypalController
  before_filter :authenticate_user!


  def create
    @course = Course.find(params[:course_id])
    payment_request = request_for_course(@course)

    success_url = payments_paypal_responses_url(:course_id => @course)
    cancel_url  = course_url(@course)
    paypal_response = paypal.setup(payment_request, success_url, cancel_url) # response = request.setup(payment_request,YOUR_SUCCESS_CALBACK_URL,YOUR_CANCEL_CALBACK_URL)
    redirect_to paypal_response.redirect_uri
  end

end