class CreateCrewmanships < ActiveRecord::Migration
  def change
    create_table :crewmanships do |t|
      t.references :mission
      t.references :user
      t.string :role
      t.string :status
      t.date :trial_expires_at
      t.datetime :canceled_at

      t.timestamps
    end
    add_index :crewmanships, :mission_id
    add_index :crewmanships, :user_id
  end
end
