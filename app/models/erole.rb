class Erole < ActiveRecord::Base
  belongs_to :member
  belongs_to :ecourse
  attr_accessible :role, :attending
end
