class RenameUserColumns < ActiveRecord::Migration
  def change
    rename_column :deliveries, :worker_id, :user_id
    rename_column :receipts, :recipient_id, :user_id
  end
end
