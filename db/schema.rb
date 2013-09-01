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

ActiveRecord::Schema.define(:version => 20121011160318) do

  create_table "answer_groups", :force => true do |t|
    t.integer  "questionnaire_id"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "answers", :force => true do |t|
    t.integer "answer_group_id"
    t.integer "question_id"
    t.string  "type"
    t.integer "value"
    t.string  "text"
    t.integer "choice_id"
    t.text    "choice_ids"
  end

  create_table "brochures", :force => true do |t|
    t.string   "type"
    t.text     "body",       :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "contacts", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "content_objects", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.string   "author"
    t.text     "description"
    t.text     "data"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "launch_number", :default => 0
    t.string   "type"
  end

  create_table "daily_journals", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "calm"
    t.boolean  "angry"
    t.boolean  "anxious"
    t.boolean  "manic"
    t.integer  "happiness_level"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.date     "created_on"
    t.string   "audio"
    t.string   "video"
  end

  create_table "hope_items", :force => true do |t|
    t.integer "client_id"
    t.string  "title"
    t.string  "type"
    t.text    "text"
    t.string  "url"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "text"
    t.date     "created_on"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "questionnaires", :force => true do |t|
    t.string "title"
  end

  create_table "questions", :force => true do |t|
    t.integer "questionnaire_id"
    t.integer "position"
    t.string  "description"
    t.text    "choices"
    t.integer "value"
    t.text    "unit"
    t.string  "type"
  end

  create_table "safety_plans", :force => true do |t|
    t.integer  "client_id"
    t.integer  "created_by"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "username"
    t.string   "full_name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "online",                 :default => false
    t.string   "avatar_url"
    t.string   "location"
    t.text     "description"
    t.integer  "primary_therapist_id"
    t.string   "roles"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
