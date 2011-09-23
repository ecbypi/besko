class CreateUsers < ActiveRecord::Migration
  def up
    drop_table :users

    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :login, :limit => 8
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :single_access_token
      t.string :perishable_token
      t.integer :failed_login_attempts
      t.string :current_login_ip
      t.string :last_login_ip
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.datetime :last_request_at
      t.boolean :approved
      t.timestamps
    end
  end

  def down
    drop_table :users

    create_table :users do |t|
      t.string   :email,                                          :null => false
      t.string   :crypted_password
      t.string   :salt
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :reset_password_token
      t.datetime :reset_password_token_expires_at
      t.datetime :reset_password_email_sent_at
      t.integer  :failed_logins_count,             :default => 0
      t.datetime :lock_expires_at
      t.datetime :last_login_at
      t.datetime :last_logout_at
      t.datetime :last_activity_at
      t.string   :remember_me_token
      t.datetime :remember_me_token_expires_at
      t.string   :activation_state
      t.string   :activation_token
      t.datetime :activation_token_expires_at
      t.string   :first_name
      t.string   :last_name
      t.string   :address
    end
  end
end
