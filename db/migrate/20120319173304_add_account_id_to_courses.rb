class AddAccountIdToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :account_id, :integer
  	add_index :courses, :account_id
  end
end
