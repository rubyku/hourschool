class Mission < ActiveRecord::Base
  belongs_to :account
  belongs_to :city
end
