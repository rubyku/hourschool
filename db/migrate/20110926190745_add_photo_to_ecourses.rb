class AddPhotoToEcourses < ActiveRecord::Migration
  def self.up
    add_column :ecourses, :photo_file_name, :string
    add_column :ecourses, :photo_content_type, :string
    add_column :ecourses, :photo_file_size, :integer
  end

  def self.down
    remove_column :ecourses, :photo_file_size
    remove_column :ecourses, :photo_content_type
    remove_column :ecourses, :photo_file_name
  end
end
