class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :account
      t.references :user
      t.boolean :admin, :null => false, :default => false

      t.timestamps
    end
    add_index :memberships, :account_id
    add_index :memberships, :user_id
  end
end
