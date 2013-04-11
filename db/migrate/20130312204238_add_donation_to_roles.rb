class AddDonationToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :donation, :integer
  end
end
