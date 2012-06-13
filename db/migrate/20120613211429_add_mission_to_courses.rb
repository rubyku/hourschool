class AddMissionToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :mission_id, :integer
    add_index :courses, :mission_id
  end
end
