class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.references :user
      t.boolean :type
      t.boolean :follow
      t.timestamps
    end
    add_index :topics, :user_id
  end
end
