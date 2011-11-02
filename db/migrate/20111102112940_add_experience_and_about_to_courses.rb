class AddExperienceAndAboutToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :experience, :text
    add_column :courses, :about, :text
  end

  def self.down
    remove_column :courses, :about
    remove_column :courses, :experience
  end
end
