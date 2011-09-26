class CreateCsuggestions < ActiveRecord::Migration
  def self.up
    create_table :csuggestions do |t|
      t.string :name
      t.string :description
      t.references :city

      t.timestamps
    end
  end

  def self.down
    drop_table :csuggestions
  end
end
