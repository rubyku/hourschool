class AddRequestedByToEsuggestions < ActiveRecord::Migration
  def self.up
    add_column :esuggestions, :requested_by, :integer
  end

  def self.down
    remove_column :esuggestions, :requested_by
  end
end
