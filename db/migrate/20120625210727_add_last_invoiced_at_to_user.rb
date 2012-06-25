class AddLastInvoicedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_invoiced_at, :datetime

  end
end
