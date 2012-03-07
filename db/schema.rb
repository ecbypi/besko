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

ActiveRecord::Schema.define(:version => 20120307035917) do

  create_table "deliveries", :force => true do |t|
    t.string   "deliverer"
    t.integer  "worker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deliveries", ["worker_id"], :name => "index_deliveries_on_worker_id"

  create_table "packages", :force => true do |t|
    t.datetime "signed_out_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "worker_id"
    t.date     "received_on"
    t.text     "comment"
    t.string   "delivered_by"
    t.integer  "recipient_id"
    t.integer  "receipt_id"
  end

  add_index "packages", ["receipt_id"], :name => "index_packages_on_receipt_id"
  add_index "packages", ["recipient_id"], :name => "index_packages_on_recipient_id"
  add_index "packages", ["worker_id"], :name => "index_packages_on_worker_id"

  create_table "receipts", :force => true do |t|
    t.text     "comment"
    t.integer  "delivery_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_packages"
    t.datetime "signed_out_at"
  end

  add_index "receipts", ["delivery_id"], :name => "index_receipts_on_delivery_id"
  add_index "receipts", ["recipient_id"], :name => "index_receipts_on_recipient_id"

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
    t.string   "login"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
