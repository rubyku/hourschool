class AddMinimumToEcourses < ActiveRecord::Migration
  def self.up
    add_column :ecourses, :minimum, :integer
  end

  def self.down
    remove_column :ecourses, :minimum
  end
end
