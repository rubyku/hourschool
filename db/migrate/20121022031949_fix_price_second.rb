class FixPriceSecond < ActiveRecord::Migration
  def self.up
    rename_column :courses, :price_second, :member_price
  end

  def self.down
  end
end
