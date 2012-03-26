class AddAccountIdToSuggestions < ActiveRecord::Migration
  def change
    add_column :suggestions, :account_id, :integer
    add_index :suggestions, :account_id
  end
end
