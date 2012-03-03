class AddSeriesToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :series_id, :integer

  end
end
