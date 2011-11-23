class AddPhonenumAndAddressAndPublicToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :phonenum, :string
    add_column :courses, :address, :string
    add_column :courses, :public, :boolean
  end

  def self.down
    remove_column :courses, :public
    remove_column :courses, :address
    remove_column :courses, :phonenum
  end
end
