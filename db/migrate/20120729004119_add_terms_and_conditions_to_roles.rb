class AddTermsAndConditionsToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :terms_and_conditions, :boolean

  end
end
