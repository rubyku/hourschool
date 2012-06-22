class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string :title
      t.text :description
      t.references :account
      t.references :city
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.timestamps
    end
    add_index :missions, :account_id
    add_index :missions, :city_id
  end
end
