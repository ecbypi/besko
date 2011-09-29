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

ActiveRecord::Schema.define(:version => 20110929182140) do

  create_table "packages", :force => true do |t|
    t.integer  "worker_id"
    t.integer  "recipient_id"
    t.string   "delivered_by"
    t.text     "comment"
    t.date     "received_on"
    t.datetime "signed_out_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "packages", ["recipient_id"], :name => "index_packages_on_recipient_id"
  add_index "packages", ["worker_id"], :name => "index_packages_on_worker_id"

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "address"
    t.string   "login",                 :limit => 8
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "failed_login_attempts"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.boolean  "approved",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
