class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :title
      t.text :description
      t.string :slug
      t.text :course_ids

      t.timestamps
    end
    add_index :tracks, :slug, unique: true
  end

  def self.down
    drop_table :tracks
  end
end
