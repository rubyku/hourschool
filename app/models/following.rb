class Following < ActiveRecord::Base
  RELATIONSHIPS = [:classmate, :teacher, :student, :friend]

  belongs_to :follower, :class_name => 'User', :foreign_key => 'follower_id'
  belongs_to :followed, :class_name => 'User', :foreign_key => 'followed_id'

  validates :relationship,  :presence => true, :format => {:with => %r{^(#{RELATIONSHIPS.join('|')})$} }

  validates :follower_id,   :presence => true
  validates :followed_id,   :presence => true, :uniqueness => { :scope => [:follower_id] }

end
