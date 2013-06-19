class AddCustomDomainToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :custom_domain, :string
  end
end
