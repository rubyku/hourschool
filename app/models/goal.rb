class Goal < Course

  before_save :set_status

  has_many :mentors,   :through => :roles, :conditions => "roles.name = 'mentor'",    :source => :user
  has_many :teammates, :through => :roles, :conditions => "roles.name = 'teammate'" , :source => :user

  def teamleader
    roles.where(:name => 'teamleader').first.user
  end

  def add_teammate(user)
    roles.create!(:name => 'teammate', :user => user)
    self
  end

  def add_mentor(user)
    roles.create!(:name => 'mentor', :user => user)
    self
  end

  def teammate?(user)
    roles.where(:name => 'teammate', :user_id => user).present?
  end

  def mentor?(user)
    roles.where(:name => 'mentor', :user_id => user).present?
  end

  private

  def set_status
    status = 'goal' if status.blank?
  end

end