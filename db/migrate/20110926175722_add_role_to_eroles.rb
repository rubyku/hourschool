class AddRoleToEroles < ActiveRecord::Migration
  def self.up
    add_column :eroles, :role, :string
    add_column :eroles, :attending, :boolean
  end

  def self.down
    remove_column :eroles, :role
    remove_column :eroles, :attending
  end
end
