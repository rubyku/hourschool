class AddInviterEmailToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :inviter_email, :string

  end
end
