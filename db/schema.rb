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

ActiveRecord::Schema.define(:version => 20131130014603) do

  create_table "active_codes", :force => true do |t|
    t.string   "code"
    t.integer  "month_count"
    t.integer  "user_id"
    t.boolean  "is_valid",    :default => true
    t.datetime "actived_at"
    t.boolean  "is_buyed",    :default => false
    t.boolean  "is_unbuyed",  :default => false
    t.datetime "buyed_at"
    t.datetime "unbuyed_at"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "active_codes", ["code"], :name => "index_active_codes_on_code", :unique => true

  create_table "anyous", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "cases_count", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "anyous", ["parent_id"], :name => "index_anyous_on_parent_id"

  create_table "case_contents", :force => true do |t|
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cases", :force => true do |t|
    t.string   "title"
    t.string   "court"
    t.string   "case_type"
    t.string   "summary"
    t.integer  "case_content_id"
    t.integer  "anyou_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "cases", ["anyou_id"], :name => "index_cases_on_anyou_id"
  add_index "cases", ["case_content_id"], :name => "index_cases_on_case_content_id", :unique => true

  create_table "device_infos", :force => true do |t|
    t.string   "udid"
    t.datetime "vip_expired_at"
    t.integer  "month_count",    :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "device_infos", ["udid"], :name => "index_device_infos_on_udid", :unique => true

  create_table "ext_laws", :force => true do |t|
    t.string   "content"
    t.integer  "law_type"
    t.integer  "law_id"
    t.integer  "source_type"
    t.integer  "source_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "ext_laws", ["law_id"], :name => "index_ext_laws_on_law_id"
  add_index "ext_laws", ["source_id"], :name => "index_ext_laws_on_source_id"
  add_index "ext_laws", ["source_type"], :name => "index_ext_laws_on_source_type"

  create_table "extensions", :force => true do |t|
    t.integer  "extending_id"
    t.string   "extended_ids"
    t.string   "extended_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "favorites", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "law_contents", :force => true do |t|
    t.text     "content",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "law_track_contents", :force => true do |t|
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "law_tracks", :force => true do |t|
    t.string   "title"
    t.string   "pub_date"
    t.integer  "law_track_content_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "law_tracks", ["law_track_content_id"], :name => "index_law_tracks_on_law_track_content_id"

  create_table "law_types", :force => true do |t|
    t.string   "name"
    t.integer  "laws_count", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "laws", :force => true do |t|
    t.string   "title"
    t.string   "pub_dept"
    t.string   "doc_id"
    t.string   "pub_date"
    t.string   "impl_date"
    t.string   "expire_date"
    t.text     "summary"
    t.integer  "law_type_id"
    t.integer  "location_id"
    t.integer  "law_content_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "laws", ["law_content_id"], :name => "index_laws_on_law_content_id", :unique => true
  add_index "laws", ["law_type_id"], :name => "index_laws_on_law_type_id"
  add_index "laws", ["location_id"], :name => "index_laws_on_location_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.integer  "laws_count", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "purchases", :force => true do |t|
    t.integer  "content"
    t.integer  "user_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.text     "receipt"
    t.boolean  "receipt_is_valid", :default => false
    t.integer  "device_info_id"
  end

  add_index "purchases", ["device_info_id"], :name => "index_purchases_on_device_info_id"
  add_index "purchases", ["user_id"], :name => "index_purchases_on_user_id"

  create_table "search_histories", :force => true do |t|
    t.string   "keyword"
    t.integer  "law_type_id"
    t.integer  "search_count", :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "search_histories", ["law_type_id"], :name => "index_search_histories_on_law_type_id"
  add_index "search_histories", ["search_count"], :name => "index_search_histories_on_search_count"

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "password_digest",        :default => "", :null => false
    t.string   "private_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.datetime "vip_expired_at"
    t.integer  "purchases_count",        :default => 0
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "udid"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["password_reset_token"], :name => "index_users_on_password_reset_token"
  add_index "users", ["private_token"], :name => "index_users_on_private_token"
  add_index "users", ["udid"], :name => "index_users_on_udid", :unique => true

end
