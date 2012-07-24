class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :mission

  #validates :course_id, :presence => true
  validates :user_id,   :presence => true, :uniqueness => { :scope => :course_id }
  validates_presence_of :note

  after_create :notify_followers


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
