class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :mission

  has_attached_file :photo, :styles => { :normal => "510x381" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "comment/:style/:id/:filename"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'application/pdf', 'application/msword', 'text/plain']

  validates :user_id,   :presence => true
  validates :body,      :presence => true

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
      UserMailer.comment_on_course(user, self, self.course, current_account).deliver unless self.user == user
    end
  end

  def notify_participants_and_students
    if self.course.account.nil? 
      current_account = nil
    else 
      current_account = self.course.account
    end
    participants_and_students.each do |user|
      UserMailer.comment_on_course(user, self, self.course, current_account).deliver unless self.user == user
    end
  end
  
  def child_comments
    Comment.where(:parent_id => self.id).order('DATE(created_at) ASC')
  end

end
