class ChangePriceToCourses < ActiveRecord::Migration
  def self.up
    change_column :courses, :price, :integer
  end

  def self.down
    change_column :courses, :price, :integer
  end
end
