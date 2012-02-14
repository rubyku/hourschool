class Followings < ActiveRecord::Migration
  def up
    create_table :followings do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.string  :status
      t.string  :relationship
      t.timestamps
    end


    add_index :followings, [:follower_id, :followed_id], :unique => true
    add_index :followings, :followed_id

    User.find_each(&:back_fill_following!)
  end

  def down
    drop_table :followings
  end
end
