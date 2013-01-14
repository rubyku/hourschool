class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :mission

  #validates :course_id, :presence => true
  validates :user_id,   :presence => true, :uniqueness => { :scope => :course_id }
  #validates_presence_of :note

  after_create :notify_followers


  def extra_tickets
    Role.where(:course_id => self.course_id, :invite_user_id => self.user_id)
  end

  def create_extra_tickets!
    return false if self.quantity.blank? || self.quantity == 1
    (self.quantity - 1).times do
      inviter = self.user
      self.course.roles.create!(:attending      => true,
                                :name           => 'student',
                                :user           => User.create_invite_user,
                                :invite_user_id => inviter.id)
    end
  end

  def member?
    self.member == true
  end

  def stripe_amount
    (total_amount * 100).to_i
  end

  def total_amount
    if quantity > 1
      extra_tickets.map(&:amount).inject(&:+)
    else
      amount
    end
  end

  def amount
    if member?
      self.course.member_price || self.course.price
    else
      self.course.price
    end
  end

  def create_crewmanship!
    Crewmanship.create!(:mission_id => self.course.mission.id, :user_id => self.user.id, :status => 'trial_active', :role => 'explorer') if self.course.mission.present? && self.user.crewmanships.where(:mission_id => self.course.mission.id).blank?
  end

  def create_membership!
    Membership.create(:user => self.user, :account => self.course.account, :admin => false) unless Membership.find_by_user_id_and_account_id(self.user.id, self.course.account.id)
  end

  def community_site?
    self.course.account.blank?
  end

  def join_crewhmanship_or_membership!
    if self.community_site?
      self.create_crewmanship!
    else
      self.create_membership!
    end
  end

  def charge_stripe!
    if self.total_amount > 0
      charge = Stripe::Charge.create(
        :amount       => self.stripe_amount,
        :currency     => "usd",
        :customer     => self.user.stripe_customer_id,
        :description  => "#{self.quantity} ticket(s) to #{self.course.name}."
      )
      extra_tickets.destroy_all and self.destroy unless charge.paid
      return charge
    end
  end


  private

    def notify_followers
      if name == 'student'
        user.fetch_followers.each do |follower|
          # UserMailer.delay.followed_signed_up_for_a_course(follower, self.user, course)
        end
      end
      return true
    end
end
