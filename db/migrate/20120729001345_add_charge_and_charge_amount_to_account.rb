class AddChargeAndChargeAmountToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :charge, :boolean, :default => true

    add_column :accounts, :charge_amount, :float

  end
end
