class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :course_id, :presence => true
  validates :user_id,   :presence => true

  ADJECTIVES = %W{witty fun sarcastic nice beautiful elegant magnificent mysterious deep inspiring sweet awesome entertaining obvious inquisitive ludicrous quirky scandalous upbeat unusual }

  def self.say_something
    "Say something... #{ADJECTIVES.shuffle.first}!"
  end

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

  def notify_participants
    participants.each do |user|
      UserMailer.comment_on_course(user, self, self.course).deliver unless self.user == user
    end
  end

end
