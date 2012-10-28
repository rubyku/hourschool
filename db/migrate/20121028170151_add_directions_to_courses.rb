class AddDirectionsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :directions, :text

  end
end
