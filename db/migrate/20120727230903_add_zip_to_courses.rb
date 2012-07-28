class AddZipToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :zip, :string

  end
end
