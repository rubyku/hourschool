class AddDonateToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :donate, :boolean

  end
end
