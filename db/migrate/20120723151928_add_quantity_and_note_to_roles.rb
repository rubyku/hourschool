class AddQuantityAndNoteToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :quantity, :integer
    add_column :roles, :note, :string
  end
end
