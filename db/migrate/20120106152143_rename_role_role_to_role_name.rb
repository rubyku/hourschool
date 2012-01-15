class RenameRoleRoleToRoleName < ActiveRecord::Migration
  def self.up
    rename_column :roles, :role, :name
  end

  def self.down
    rename_column :roles, :name, :role
  end
end
