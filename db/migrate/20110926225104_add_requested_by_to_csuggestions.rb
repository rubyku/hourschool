class AddRequestedByToCsuggestions < ActiveRecord::Migration
  def self.up
    add_column :csuggestions, :requested_by, :integer
  end

  def self.down
    remove_column :csuggestions, :requested_by
  end
end
