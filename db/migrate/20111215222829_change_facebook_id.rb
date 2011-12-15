class ChangeFacebookId < ActiveRecord::Migration
  def self.up
    rename_column :users, :facebook, :facebook_id
    rename_column :users, :twitter,  :twitter_id
  end

  def self.down
    rename_column :users, :facebook_id, :facebook
    rename_column :users, :twitter_id,  :twitter
  end
end
