class AddNameAndDomainToEnterprises < ActiveRecord::Migration
  def self.up
    add_column :enterprises, :name, :string
    add_column :enterprises, :domain, :string
  end

  def self.down
    remove_column :enterprises, :domain
    remove_column :enterprises, :name
  end
end
