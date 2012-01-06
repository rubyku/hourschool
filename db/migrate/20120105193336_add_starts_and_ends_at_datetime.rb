class AddStartsAndEndsAtDatetime < ActiveRecord::Migration
  def self.up
    add_column :courses, :starts_at, :datetime
    add_column :courses, :ends_at,   :datetime
  end

  def self.down
    remove_column :courses, :starts_at
    remove_column :courses, :ends_at
  end
end
