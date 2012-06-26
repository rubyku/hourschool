class AddLastInvoicedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_invoiced_at, :datetime
    add_column :users, :billing_day_of_month, :integer
    add_column :users, :stripe_customer_id, :string
  end
end
