class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :mission
  belongs_to :account

  has_attached_file :photo, :styles => { :normal => "510x381" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "comment/:style/:id/:filename"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'application/pdf', 'application/msword', 'text/plain']

  validates :user_id,   :presence => true
  # validates :body,      :presence => true

  default_scope :order => 'created_at DESC'

  def body_with_links
    stripped_message = ERB::Util.html_escape(self.body)
    message_with_link = stripped_message.gsub(/(http:\/\/(\S*\.\S*)|https:\/\/(\S*\.\S*))/) {"<a href=\"#{$1}\" target='_blank' rel='nofollow'>#{$1}</a>"}
    return message_with_link.html_safe
  rescue => ex
    return body
  end

  def participants
    (course.comments.map(&:user) << course.teacher).uniq
  end

  def participants_and_students
    (participants + course.students << course.teacher).uniq
  end

  def notify_participants
    if self.course.account.nil?
      current_account = nil
    else
      current_account = self.course.account
    end
    participants.each do |user|
      Resque.enqueue(CourseComments, user.id, self.id, self.course.id, current_account.try(:id)) unless self.user == user
    end
  end

  def notify_participants_and_students
    if self.course.account.nil?
      current_account = nil
    else
      current_account = self.course.account
    end
    participants_and_students.each do |user|
      Resque.enqueue(CourseComments, user.id, self.id, self.course.id, current_account.try(:id)) unless self.user == user
    end
  end

  def parent_comment
    Comment.where(:id => self.parent_id).first if self.parent_id
  end

  def child_comments
    Comment.where(:parent_id => self.id).reverse_order
  end

  class AccountNewComment
    @queue = :account_new_comment

    def self.perform(user_id, account_id, comment_id)
      user    = User.find(user_id)
      account = Account.find(account_id) if account_id
      comment = Comment.find(comment_id)
      UserMailer.account_new_comment(user, account, comment).deliver
    end
  end

  class CourseComments
    @queue = :course_comments

    def self.perform(user_id, comment_id, course_id, current_account_id)
      user    = User.find(user_id)
      comment = Comment.find(comment_id)
      course  = Course.find(course_id)
      account = Account.find(current_account_id) if current_account_id
      UserMailer.course_comments(user, comment, course, account).deliver
    end
  end

end
