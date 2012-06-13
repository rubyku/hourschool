class AddMissionToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :mission_id, :integer
    add_index :roles, :mission_id
  end
end
