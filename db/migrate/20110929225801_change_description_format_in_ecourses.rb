class ChangeDescriptionFormatInEcourses < ActiveRecord::Migration
  def self.up
   change_column :ecourses, :description, :text
  end

  def self.down
   change_column :ecourses, :description, :string
  end
end
