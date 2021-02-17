# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2014_09_07_000305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deliveries", force: :cascade do |t|
    t.string "deliverer"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "delivered_on"
    t.index ["delivered_on"], name: "index_deliveries_on_delivered_on"
    t.index ["user_id"], name: "index_deliveries_on_worker_id"
  end

  create_table "forwarding_addresses", force: :cascade do |t|
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "postal_code"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_forwarding_addresses_on_user_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.text "comment"
    t.integer "delivery_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "number_packages"
    t.datetime "signed_out_at"
    t.index ["delivery_id"], name: "index_receipts_on_delivery_id"
    t.index ["user_id"], name: "index_receipts_on_recipient_id"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["user_id", "title"], name: "index_user_roles_on_user_id_and_title", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "login"
    t.string "email", default: "", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "street"
    t.boolean "forwarding_account", default: false
    t.datetime "activated_at"
    t.index ["activated_at"], name: "index_users_on_activated_at"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
