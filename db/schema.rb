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

ActiveRecord::Schema.define(:version => 20120906091923) do

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "intro"
    t.text     "body"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "user_id"
    t.string   "image"
    t.text     "emails"
    t.boolean  "moderated",               :default => true
    t.datetime "published_at"
    t.string   "target"
    t.datetime "duedate_at"
    t.string   "ttype"
    t.string   "status",                  :default => "active"
    t.time     "deleted_at"
    t.integer  "sub_oigame_id"
    t.string   "default_message_subject"
    t.text     "default_message_body"
    t.boolean  "priority",                :default => false
    t.integer  "messages_count",          :default => 0
    t.integer  "petitions_count",         :default => 0
    t.boolean  "commentable",             :default => true
  end

  add_index "campaigns", ["deleted_at"], :name => "index_on_campaigns_deleted_at"
  add_index "campaigns", ["moderated"], :name => "index_campaigns_on_moderated"
  add_index "campaigns", ["slug"], :name => "index_campaigns_on_slug"
  add_index "campaigns", ["status"], :name => "index_on_campaigns_status"
  add_index "campaigns", ["sub_oigame_id"], :name => "index_campaigns_on_sub_oigame_id"
  add_index "campaigns", ["user_id"], :name => "index_campaigns_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "mailing",    :default => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "campaign_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "email"
    t.boolean  "validated",   :default => false
    t.string   "token"
    t.text     "body"
    t.string   "subject"
    t.string   "name"
  end

  add_index "messages", ["campaign_id"], :name => "index_messages_on_campaign_id"
  add_index "messages", ["validated"], :name => "index_messages_on_validated"

  create_table "petitions", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "email"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "validated",   :default => false
    t.string   "token"
    t.string   "name"
  end

  add_index "petitions", ["campaign_id"], :name => "index_petitions_on_campaign_id"
  add_index "petitions", ["validated"], :name => "index_petitions_on_validated"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sub_oigames", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "html_header"
    t.text     "html_footer"
    t.text     "html_style"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "logo"
    t.text     "logobase64"
    t.string   "from"
    t.time     "deleted_at"
    t.text     "mail_message"
    t.integer  "campaigns_count", :default => 0
  end

  add_index "sub_oigames", ["deleted_at"], :name => "index_on_sub_oigames_deleted_at"
  add_index "sub_oigames", ["slug"], :name => "index_sub_oigames_on_slug", :unique => true, :length => {"slug"=>254}

  create_table "sub_oigames_users", :id => false, :force => true do |t|
    t.integer "sub_oigame_id"
    t.integer "user_id"
  end

  create_table "tolk_locales", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_locales", ["name"], :name => "index_tolk_locales_on_name", :unique => true

  create_table "tolk_phrases", :force => true do |t|
    t.text     "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tolk_translations", :force => true do |t|
    t.integer  "phrase_id"
    t.integer  "locale_id"
    t.text     "text"
    t.text     "previous_text"
    t.boolean  "primary_updated", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_translations", ["phrase_id", "locale_id"], :name => "index_tolk_translations_on_phrase_id_and_locale_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "mailing",                :default => false
    t.string   "name"
    t.string   "vat"
    t.integer  "campaigns_count",        :default => 0
    t.string   "provider"
    t.string   "uid"
    t.integer  "roles_mask"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true, :length => {"authentication_token"=>254}
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true, :length => {"confirmation_token"=>254}
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true, :length => {"email"=>254}
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true, :length => {"reset_password_token"=>254}

end
