class Account < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships
  has_many :courses
  has_many :suggestions

  validates :name, :subdomain, :presence => true
  validates_uniqueness_of :subdomain

  before_validation :format_subdomain, :on => :create

  scope :open, where(:private => false)
  scope :private, where(:private => true)

  def self.public_ids
    self.open.collect(&:id) + [nil]
  end

  private
  def format_subdomain
    self.subdomain = self.subdomain.parameterize
  end

  def valid_email?(email)
    email.match(/#{email_regex}/) ? true : false
  end

  def invalid_email?(email)
    !valid_email?(email)
  end

  def valid_user?(user)
    return true if email_regex.blank?
    email = user.try(:email) || ""
    valid_email?(email)
  end

  def invalid_user?(user)
    !valid_user?(user)
  end
end
