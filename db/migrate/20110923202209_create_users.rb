class CreateUsers < ActiveRecord::Migration
  def up
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
      t.boolean :approved, :default => false
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
