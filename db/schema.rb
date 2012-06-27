# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120627164319) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.string   "email_regex"
    t.text     "description"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "private",            :default => false, :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "accounts", ["subdomain"], :name => "index_accounts_on_subdomain", :unique => true

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_notes", :force => true do |t|
    t.integer  "resource_id",     :null => false
    t.string   "resource_type",   :null => false
    t.integer  "admin_user_id"
    t.string   "admin_user_type"
    t.text     "body"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "admin_notes", ["admin_user_type", "admin_user_id"], :name => "index_admin_notes_on_admin_user_type_and_admin_user_id"

  create_table "admin_users", :force => true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "cities", :force => true do |t|
    t.integer  "zip"
    t.string   "area"
    t.string   "name"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
    t.string   "time_zone"
    t.string   "country_code"
    t.integer  "population"
  end

  create_table "comments", :force => true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "mission_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "comment_type"
  end

  add_index "comments", ["course_id"], :name => "index_comments_on_course_id"
  add_index "comments", ["mission_id"], :name => "index_comments_on_mission_id"
  add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "courses", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "price"
    t.integer  "max_seats"
    t.time     "time"
    t.string   "place_name"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "min_seats"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.string   "time_range"
    t.string   "status"
    t.text     "experience"
    t.text     "teaser"
    t.string   "coursetag"
    t.string   "phone_number"
    t.string   "address"
    t.boolean  "public"
    t.string   "slug"
    t.date     "date"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "nosignup"
    t.boolean  "happening",          :default => true
    t.boolean  "featured",           :default => false
    t.boolean  "donate"
    t.integer  "series_id"
    t.integer  "account_id",         :default => 0,     :null => false
    t.boolean  "seed",               :default => false, :null => false
    t.integer  "mission_id"
  end

  add_index "courses", ["account_id"], :name => "index_courses_on_account_id"
  add_index "courses", ["featured"], :name => "index_courses_on_featured"
  add_index "courses", ["mission_id"], :name => "index_courses_on_mission_id"
  add_index "courses", ["slug"], :name => "index_courses_on_slug", :unique => true

  create_table "courses_topics", :id => false, :force => true do |t|
    t.integer "course_id"
    t.integer "topic_id"
  end

  add_index "courses_topics", ["course_id", "topic_id"], :name => "index_courses_topics_on_course_id_and_topic_id"

  create_table "crewmanships", :force => true do |t|
    t.integer  "mission_id"
    t.integer  "user_id"
    t.string   "role"
    t.string   "status"
    t.date     "trial_expires_at"
    t.datetime "canceled_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "crewmanships", ["mission_id"], :name => "index_crewmanships_on_mission_id"
  add_index "crewmanships", ["user_id"], :name => "index_crewmanships_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "ecourses", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.float    "price"
    t.integer  "seats"
    t.date     "date"
    t.time     "time"
    t.string   "place"
    t.integer  "enterprise_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "minimum"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  create_table "enterprises", :force => true do |t|
    t.string   "area"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.string   "domain"
  end

  create_table "eroles", :force => true do |t|
    t.integer  "member_id"
    t.integer  "ecourse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.boolean  "attending"
  end

  create_table "esuggestions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "enterprise_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "requested_by"
  end

  create_table "followings", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.string   "status"
    t.string   "relationship"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "followings", ["followed_id"], :name => "index_followings_on_followed_id"
  add_index "followings", ["follower_id", "followed_id"], :name => "index_followings_on_follower_id_and_followed_id", :unique => true

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "invites", :force => true do |t|
    t.integer  "inviter_id"
    t.integer  "invitee_id"
    t.string   "invitee_email"
    t.text     "message"
    t.integer  "invitable_id"
    t.string   "invitable_type"
    t.string   "invite_action"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "invites", ["invitable_id"], :name => "index_invites_on_invitable_id"
  add_index "invites", ["invitable_type"], :name => "index_invites_on_invitable_type"
  add_index "invites", ["invitee_id"], :name => "index_invites_on_invitee_id"
  add_index "invites", ["inviter_id"], :name => "index_invites_on_inviter_id"

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
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.integer  "enterprise_id"
  end

  add_index "members", ["email"], :name => "index_members_on_email", :unique => true
  add_index "members", ["enterprise_id"], :name => "index_members_on_enterprise_id"
  add_index "members", ["reset_password_token"], :name => "index_members_on_reset_password_token", :unique => true

  create_table "memberships", :force => true do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.boolean  "admin",      :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "memberships", ["account_id"], :name => "index_memberships_on_account_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "missions", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "account_id"
    t.integer  "city_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "missions", ["account_id"], :name => "index_missions_on_account_id"
  add_index "missions", ["city_id"], :name => "index_missions_on_city_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id_id"
    t.integer  "course_id_id"
    t.string   "alert"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.float    "amount"
    t.string   "transaction_id"
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pre_mission_signups", :force => true do |t|
    t.string   "email"
    t.string   "mission"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "pre_mission_signups", ["user_id"], :name => "index_pre_mission_signups_on_user_id"

  create_table "roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "attending"
    t.integer  "mission_id"
  end

  add_index "roles", ["mission_id"], :name => "index_roles_on_mission_id"

  create_table "schedule_events", :force => true do |t|
    t.integer  "series_id"
    t.date     "publish_on"
    t.datetime "starts_at"
    t.boolean  "published"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "series", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "last_course_id"
    t.integer  "student_count"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.text     "schedule_hash"
    t.integer  "publish_days_before"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "subdomains", :force => true do |t|
    t.string   "name"
    t.integer  "enterprise_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "subscription_charges", :force => true do |t|
    t.integer  "user_id"
    t.text     "params"
    t.decimal  "amount",                  :precision => 8, :scale => 2
    t.boolean  "paid",                                                  :default => false, :null => false
    t.string   "stripe_card_fingerprint"
    t.string   "stripe_customer_id"
    t.string   "stripe_id"
    t.string   "card_last_4"
    t.string   "card_type"
    t.text     "description"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
  end

  add_index "subscription_charges", ["user_id"], :name => "index_subscription_charges_on_user_id"

  create_table "subscriptions", :force => true do |t|
    t.string   "subscribable_type"
    t.integer  "subscribable_id"
    t.string   "stripe_customer_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "suggestions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "requested_by"
    t.string   "slug"
    t.integer  "account_id"
  end

  add_index "suggestions", ["account_id"], :name => "index_suggestions_on_account_id"
  add_index "suggestions", ["slug"], :name => "index_csuggestions_on_slug", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "mission_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "topics", ["mission_id"], :name => "index_topics_on_mission_id"
  add_index "topics", ["user_id"], :name => "index_topics_on_user_id"

  create_table "tracks", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "slug"
    t.text     "course_ids"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tracks", ["slug"], :name => "index_tracks_on_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "fb_token"
    t.boolean  "admin",                                 :default => false
    t.string   "zip"
    t.text     "bio"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "referral"
    t.string   "twitter_id"
    t.string   "facebook_id"
    t.string   "web"
    t.string   "slug"
    t.string   "legacy_password_hash"
    t.string   "legacy_password_salt"
    t.string   "time_zone"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "status"
    t.integer  "city_id"
    t.string   "preferences"
    t.datetime "last_invoiced_at"
    t.integer  "billing_day_of_month"
    t.string   "stripe_customer_id"
  end

  add_index "users", ["city_id"], :name => "index_users_on_city_id"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
