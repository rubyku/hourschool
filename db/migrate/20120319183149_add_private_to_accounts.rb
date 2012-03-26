class AddPrivateToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :private, :boolean, :null => false, :default => false
  end
end
