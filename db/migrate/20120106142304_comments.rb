class Comments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :course_id, :integer
      t.column :user_id,   :integer
      t.column :body,      :text
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end

