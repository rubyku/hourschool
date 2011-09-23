class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates_presence_of :name
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :organization, :email, :password, :password_confirmation, :remember_me
  has_friendly_id :name, :use_slug => true, :strip_non_ascii => true
  
end
