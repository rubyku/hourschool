class AddInviterNameToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :inviter_name, :string

  end
end
