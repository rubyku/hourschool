class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name
  validate :valid_member_domain
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :organization, :email, :password, :password_confirmation, :remember_me, :enterprise_id
  belongs_to :enterprise

  has_many :eroles, :dependent => :destroy
   has_many :ecourses, :through => :eroles

  acts_as_voter

    def member_domain
      index1 = email.index('@')
      index2 = email.index('.com')
      domain = email[index1+1..index2-1]
    end

    def domain
      member_domain
    end

    def org
      Enterprise.find_by_domain(member_domain).name
    end

    def student_for
      return self.eroles.where(:role => 'student').count
    end

    def ecourses_for_which_is_a_student
      return self.eroles.where(:role => 'student').limit(20).collect(&:ecourse)
    end

    def ecourses_for_which_is_a_teacher
      return self.eroles.where(:role => 'teacher').limit(20).collect(&:ecourse)
    end

    def teacher_for
      return self.eroles.where(:role => 'teacher').count
    end

    def is_teacher_for?(ecourse)
      teaching_courses = self.eroles.where(:role => 'teacher').collect{|c| c.ecourse_id}
      return teaching_courses.include?(ecourse.id)
    end

    private
    def valid_member_domain
      index1 = email.index('@')
      index2 = email.index('.com')
      domain = email[index1+1..index2-1]
      if SUPPORTED_DOMAINS.include?(domain)
        return
      else
        errors.add(:email, "Your organization has not yet participated in hourschool")
      end
    end

end
