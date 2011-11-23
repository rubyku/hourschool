class AddReferralToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :referral, :string
  end

  def self.down
    remove_column :users, :referral
  end
end
