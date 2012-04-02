class AddSeedToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :seed, :boolean, :null => false, :default => false
  end
end
