class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :inviter
      t.references :invitee
      t.string :invitee_email
      t.text :message
      t.references :invitable
      t.string :invitable_type
      t.string :invite_action
      t.timestamps
    end
    add_index :invites, :inviter_id
    add_index :invites, :invitee_id
    add_index :invites, :invitable_id
    add_index :invites, :invitable_type
  end
end
