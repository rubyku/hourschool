class AddAboutToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :about, :text
  end
end
