class ChangeDescriptionFormatInCourses < ActiveRecord::Migration
  def self.up
   change_column :courses, :description, :text
  end

  def self.down
   change_column :courses, :description, :string
  end
end
