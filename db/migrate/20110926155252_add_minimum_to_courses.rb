class AddMinimumToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :minimum, :integer
  end

  def self.down
    remove_column :courses, :minimum
  end
end
