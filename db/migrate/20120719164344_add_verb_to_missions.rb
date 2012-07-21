class AddVerbToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :verb, :string

  end
end
