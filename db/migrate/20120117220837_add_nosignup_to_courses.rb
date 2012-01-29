class AddNosignupToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :nosignup, :boolean
  end

  def self.down
    remove_column :courses, :nosignup
  end
end
