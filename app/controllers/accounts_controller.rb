class AccountsController < ApplicationController
  before_filter :authenticate_admin!, :except => [:new, :create]

  def new
    @account = Account.new
    @user = User.new
    @errors = []
  end

  def edit
    @account = current_account
  end

  def create
    @account = Account.new(params[:account])
    @account.valid?

    if user_signed_in?
      if @account.valid? && @account.save
        @user = current_user
        Membership.create!(:user => current_user, :account => @account, :admin => true)
        # seed_course_and_user
        redirect_to(learn_url(:admin, :subdomain => @account.subdomain)) && return
      end
    else
      @user = User.new_with_session(params[:user], session)
      @user.valid?
      if (@user.valid? && @account.valid?) && (@user.save && @account.save)
        sign_in('user', @user)
        Membership.create!(:user => @user, :account => @account, :admin => true)
        seed_course_and_user
        redirect_to(learn_url(:admin, :subdomain => @account.subdomain)) && return
      end
    end

    # somethings wrong if we made it this far, render form
    @errors = @account.errors.full_messages
    @errors += @user.errors.full_messages unless user_signed_in?
    flash.now['alert'] = "Oops. Double check the errors below."
    render :action => "new"
  end

  def show
    # admins only
    @account = current_account
  end

  def update
    @account = current_account

    if @account.update_attributes(params[:account])
      redirect_to(root_url, :notice => 'Account was successfully updated.')
    else
      render :action => "edit"
    end
  end

  private
  # def seed_course_and_user
  #   # make ruby member of this school
  #   Membership.create!(:user_id => 1, :account => @account) unless Membership.find_by_user_id_and_account_id(1, @account.id)
  # 
  #   city    = City.find_or_create_by_name_and_state(@user.city, @user.state)
  #   @course = Course.create!(
  #     :title => "How to get the most out of your school",
  #     :description => "Yeah!",
  #     :price => 0,
  #     :max_seats => 10,
  #     :min_seats => 1,
  #     :place_name => "webinar",
  #     :status => "live",
  #     :date => Date.today,
  #     :time_range => "whenever you're available",
  #     :phone_number => "(877) 246-4689",
  #     :account => @account,
  #     :city => city,
  #     :seed => true
  #   )
  #   # make ruby the teacher (could be ruby)
  #   @course.roles.create!(:attending => true, :name => 'teacher', :user_id => 1)
  # end
end
