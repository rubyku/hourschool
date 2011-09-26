class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :title
      t.string :description
      t.float :price
      t.integer :seats
      t.date :date
      t.time :time
      t.string :place
      t.references :city

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
