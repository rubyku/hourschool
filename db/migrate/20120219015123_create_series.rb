class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.string  :name
      t.string  :slug
      t.integer :last_course_id
      t.integer :student_count
      
      t.timestamps
    end
  end
end
