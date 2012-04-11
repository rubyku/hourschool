class ChangeCoursesAccountIdToDefaultToZero < ActiveRecord::Migration
  def up
  	change_column :courses, :account_id, :integer, :null => false, :default => 0
  end

  def down
  	change_column :courses, :account_id, :integer, :null => true
  end
end
