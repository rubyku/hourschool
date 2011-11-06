class AddCoursetagToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :coursetag, :string
  end

  def self.down
    remove_column :courses, :coursetag
  end
end
