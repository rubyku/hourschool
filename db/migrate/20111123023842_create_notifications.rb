class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.references :user_id
      t.references :course_id
      t.string :alert
      t.string :action

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
