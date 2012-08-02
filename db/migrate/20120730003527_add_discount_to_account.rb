class AddDiscountToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :discount, :float

  end
end
