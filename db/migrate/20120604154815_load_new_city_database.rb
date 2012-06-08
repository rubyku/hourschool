class LoadNewCityDatabase < ActiveRecord::Migration
  def up
    add_column :cities, :country_code, :string
    add_column :cities, :population, :integer
  end

  def down
  end
end
