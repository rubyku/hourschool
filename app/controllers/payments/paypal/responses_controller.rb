# This controller creates the PayPal Response
# Note: that `paypal` and `request_for_course` are in paypal_controller.rb

class Payments::Paypal::ResponsesController < Payments::PaypalController
  before_filter :authenticate_user!

  def create
    @course   = Course.find(params[:course_id])
    token     = params[:token]
    payer_id  = params[:PayerID]

    payment_request = request_for_course(@course)

    details = paypal.details(token)
    # payment_response = paypal.details(token)
    paypal.checkout!(token, payer_id, payment_request)

    @payment = Payment.new(
      :transaction_amount => details.amount.total.to_s,
      :transaction_id     => token,
      :user               => current_user,
      :course             => @course
    )

     if @payment.save
        @user = current_user
        @role = @course.roles.create!(:attending => true, :name => 'student', :user => current_user)
        UserMailer.send_course_registration_mail(current_user.email, current_user.name, @course, current_account).deliver
        UserMailer.send_course_registration_to_teacher_mail(current_user.email, current_user.name, @course, current_account).deliver
        redirect_to confirm_path(:id => @course.id)
    else
      redirect_to @course, :notice => "Sorry you couldn't make it this time. Next time?"
    end
  end

end