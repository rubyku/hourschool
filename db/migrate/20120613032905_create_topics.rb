class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.references :user
      t.references :mission
      t.timestamps
    end
    add_index :topics, :user_id
    add_index :topics, :mission_id
  end
end
