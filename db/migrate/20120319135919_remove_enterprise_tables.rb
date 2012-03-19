class RemoveEnterpriseTables < ActiveRecord::Migration
  def up
  	drop_table :esuggestions
  	drop_table :enterprises
    drop_table :ecourses
    drop_table :subdomains
    drop_table :members
    # cant get rid of this index for some reason
    # remove_index "members", "index_members_on_enterprise_id"
    # remove_index "members", "index_members_on_email"
    # remove_index "members", "index_members_on_reset_password_token"
  end

  def down
  	create_table :esuggestions do |t|
      t.string :name
      t.string :description
      t.references :enterprise

      t.timestamps
    end
    create_table :enterprises do |t|
      t.string :area

      t.timestamps
    end
    create_table :ecourses do |t|
      t.string :title
      t.string :description
      t.float :price
      t.integer :seats
      t.date :date
      t.time :time
      t.string :place
      t.references :enterprise

      t.timestamps
    end
    create_table :subdomains do |t|
      t.string :name
      t.references :enterprise

      t.timestamps
    end
    create_table "members", :force => true do |t|
      t.string   "email",                                 :default => "", :null => false
      t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                         :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "name"
      t.string   "organization"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "enterprise_id"
    end

    # cant drop the indexes above for some reason??
    # add_index "members", ["enterprise_id"], :name => "index_members_on_enterprise_id"
    # add_index "members", ["email"], :name => "index_members_on_email", :unique => true
    # add_index "members", ["reset_password_token"], :name => "index_members_on_reset_password_token", :unique => true
  end
end
