class CreateEcourses < ActiveRecord::Migration
  def self.up
    create_table :ecourses do |t|
      t.string :title
      t.string :description
      t.float :price
      t.integer :seats
      t.date :date
      t.time :time
      t.string :place
      t.references :enterprise

      t.timestamps
    end
  end

  def self.down
    drop_table :ecourses
  end
end
