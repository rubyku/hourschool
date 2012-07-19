class AddStatusToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :status, :string

  end
end
