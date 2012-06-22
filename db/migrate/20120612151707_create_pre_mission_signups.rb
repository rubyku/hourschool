class CreatePreMissionSignups < ActiveRecord::Migration
  def change
    create_table :pre_mission_signups do |t|
      t.string :email
      t.string :mission
      t.text :description
      t.references :user

      t.timestamps
    end
    add_index :pre_mission_signups, :user_id
  end
end
