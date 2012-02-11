class UserVerified < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
       t.confirmable
     end
     add_index :users, :confirmation_token,   :unique => true
     User.find_each do |user|
       user.confirm!
     end
  end

  def down
    remove_column :users, :confirmation_sent_at
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_token
  end
end
