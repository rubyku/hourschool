class AddAccountIdToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :account_id, :integer, :null => false, :default => 0
  	add_index :courses, :account_id
  end
end
