class RenameCRolesToRoles < ActiveRecord::Migration
  def self.up
    rename_table :croles, :roles
  end

  def self.down
    rename_table :roles, :croles
  end
end
