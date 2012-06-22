class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :subscribable_type
      t.integer :subscribable_id
      t.string :stripe_customer_id

      t.timestamps
    end
  end
end
