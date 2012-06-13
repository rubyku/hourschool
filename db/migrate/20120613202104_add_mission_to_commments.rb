class AddMissionToCommments < ActiveRecord::Migration
  def change
    add_column :comments, :mission_id, :integer
    add_index :comments, :mission_id
  end
end
