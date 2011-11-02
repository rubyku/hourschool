class AddStatusToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :status, :string
  end

  def self.down
    remove_column :courses, :status
  end
end
