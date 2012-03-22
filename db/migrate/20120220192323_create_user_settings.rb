class CreateUserSettings < ActiveRecord::Migration
  def self.up
    create_table :user_settings do |t|
      t.integer :user_id
      t.integer :preferences, :default => 0, :null => false
      t.timestamps
    end
    add_index :user_settings, [:user_id], :unique => true
    
    User.find_each do |user|
      setting = UserSettings.create(:user => user)
      setting.update_attributes(:auto_follow_classmates => false)
    end
  end

  def self.down
    drop_table :user_settings
  end
end
