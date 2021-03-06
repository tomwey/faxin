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

ActiveRecord::Schema.define(:version => 20141113134523) do

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

  create_table "binds", :force => true do |t|
    t.string   "email"
    t.string   "udid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "case_contents", :force => true do |t|
    t.text     "content",    :limit => 16777215
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "cases", :force => true do |t|
    t.string   "title"
    t.string   "court"
    t.string   "case_type"
    t.string   "summary"
    t.integer  "case_content_id"
    t.integer  "anyou_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "visit_count",     :default => 0
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

  create_table "favorite_versions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "folder_version", :default => 0
    t.integer  "version",        :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "favorite_versions", ["user_id"], :name => "index_favorite_versions_on_user_id"

  create_table "favorites", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "law_type_id"
    t.integer  "law_article_id"
    t.string   "state",          :default => "A"
    t.boolean  "visible",        :default => true
    t.integer  "favorite_type",  :default => 1
    t.datetime "favorited_at"
    t.integer  "version",        :default => 0
    t.string   "law_title"
    t.integer  "folder_id"
  end

  add_index "favorites", ["favorited_at"], :name => "index_favorites_on_favorited_at"
  add_index "favorites", ["folder_id"], :name => "index_favorites_on_folder_id"
  add_index "favorites", ["law_article_id"], :name => "index_favorites_on_law_article_id"
  add_index "favorites", ["law_type_id"], :name => "index_favorites_on_law_type_id"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"
  add_index "favorites", ["version"], :name => "index_favorites_on_version"

  create_table "folders", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "version"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "state"
    t.boolean  "visible",    :default => true
  end

  add_index "folders", ["user_id"], :name => "index_folders_on_user_id"

  create_table "invites", :force => true do |t|
    t.string   "code"
    t.string   "invitee_email"
    t.integer  "user_id"
    t.boolean  "is_actived",    :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "invites", ["code"], :name => "index_invites_on_code", :unique => true
  add_index "invites", ["invitee_email"], :name => "index_invites_on_invitee_email"
  add_index "invites", ["user_id"], :name => "index_invites_on_user_id"

  create_table "judge_paper_contents", :force => true do |t|
    t.text     "content",    :limit => 16777215
    t.integer  "content_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "judge_paper_contents", ["content_id"], :name => "index_judge_paper_contents_on_content_id", :unique => true

  create_table "judge_papers", :force => true do |t|
    t.string   "title"
    t.string   "court"
    t.string   "summary"
    t.string   "commited_at"
    t.integer  "sort"
    t.integer  "content_id"
    t.integer  "visit_count", :default => 0
    t.integer  "type_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "judge_papers", ["commited_at"], :name => "index_judge_papers_on_commited_at"
  add_index "judge_papers", ["content_id"], :name => "index_judge_papers_on_content_id", :unique => true
  add_index "judge_papers", ["sort"], :name => "index_judge_papers_on_sort"
  add_index "judge_papers", ["type_id"], :name => "index_judge_papers_on_type_id"

  create_table "law_contents", :force => true do |t|
    t.text     "content",    :limit => 16777215, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "law_tags", :force => true do |t|
    t.string   "name"
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
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "visit_count",    :default => 0
  end

  add_index "laws", ["law_content_id"], :name => "index_laws_on_law_content_id", :unique => true
  add_index "laws", ["law_type_id"], :name => "index_laws_on_law_type_id"
  add_index "laws", ["location_id"], :name => "index_laws_on_location_id"

  create_table "lawyer_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lawyer_types_lawyers", :id => false, :force => true do |t|
    t.integer "lawyer_id"
    t.integer "lawyer_type_id"
  end

  create_table "lawyers", :force => true do |t|
    t.string   "real_name"
    t.string   "lawyer_card"
    t.string   "city"
    t.string   "law_firm"
    t.string   "lawyer_card_image"
    t.string   "mobile"
    t.text     "intro"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "state",             :default => 1
  end

  add_index "lawyers", ["lawyer_card"], :name => "index_lawyers_on_lawyer_card", :unique => true
  add_index "lawyers", ["mobile"], :name => "index_lawyers_on_mobile", :unique => true

  create_table "lawyers_lawyer_types", :id => false, :force => true do |t|
    t.integer "lawyer_id"
    t.integer "lawyer_type_id"
  end

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
  end

  add_index "purchases", ["user_id"], :name => "index_purchases_on_user_id"

  create_table "reports", :force => true do |t|
    t.string   "law_title"
    t.integer  "law_type_id"
    t.integer  "law_id"
    t.string   "content"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "search_histories", :force => true do |t|
    t.string   "keyword"
    t.integer  "law_type_id"
    t.integer  "search_count", :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "search_histories", ["law_type_id"], :name => "index_search_histories_on_law_type_id"
  add_index "search_histories", ["search_count"], :name => "index_search_histories_on_search_count"

  create_table "site_configs", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
    t.string   "registered_os"
    t.datetime "last_logined_at"
    t.string   "last_logined_os"
    t.integer  "invites_count",          :default => 0
    t.integer  "profile_id"
    t.string   "profile_type"
    t.string   "avatar"
    t.string   "nickname"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["password_reset_token"], :name => "index_users_on_password_reset_token"
  add_index "users", ["private_token"], :name => "index_users_on_private_token"
  add_index "users", ["profile_id"], :name => "index_users_on_profile_id"
  add_index "users", ["profile_type"], :name => "index_users_on_profile_type"
  add_index "users", ["udid"], :name => "index_users_on_udid", :unique => true

end
