class AddUserForwardingAccountColumn < ActiveRecord::Migration
  def change
    add_column :users, :forwarding_account, :boolean, default: false
  end
end
