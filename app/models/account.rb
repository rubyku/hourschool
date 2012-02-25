class Account < ActiveRecord::Base

  validates :name, :subdomain, :presence => true

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
