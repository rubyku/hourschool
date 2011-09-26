class AddRoleToCroles < ActiveRecord::Migration
  def self.up
    add_column :croles, :role, :string
    add_column :croles, :attending, :boolean
  end

  def self.down
    remove_column :croles, :role
    remove_column :croles, :attending
  end
end
