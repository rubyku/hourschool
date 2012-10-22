class AddPriceSecondToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :price_second, :integer

  end
end
