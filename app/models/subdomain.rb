class Subdomain < ActiveRecord::Base
  belongs_to :enterprise
  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name
end
