class AddTimeRangeToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :time_range, :string
  end

  def self.down
    remove_column :courses, :time_range
  end
end
