class AddStripeIdToRole < ActiveRecord::Migration
  def change
    add_column :roles, :stripe_id, :string
  end
end
