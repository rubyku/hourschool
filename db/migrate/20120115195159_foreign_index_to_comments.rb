class ForeignIndexToComments < ActiveRecord::Migration
  def self.up
    add_index :comments, :user_id
    add_index :comments, :course_id
  end

  def self.down
    remove_index :comments, :user_id
    remove_index :comments, :course_id
  end
end
