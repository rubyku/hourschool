class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.string :subdomain
      t.string :email_regex
      t.text   :description
      t.timestamps
    end
    add_index :accounts, :subdomain, :unique => true
  end

  def self.down
    drop_table :accounts
  end
end
