class CreateSubscriptionCharges < ActiveRecord::Migration
  def change
    create_table :subscription_charges do |t|
      t.references :user
      t.text :params
      t.decimal :amount, :precision => 8, :scale => 2
      t.boolean :paid, :default => false, :null => false
      t.string :stripe_card_fingerprint
      t.string :stripe_customer_id
      t.string :stripe_id
      t.string :card_last_4
      t.string :card_type
      t.text :description
      t.timestamps
    end
    add_index :subscription_charges, :user_id
  end
end
