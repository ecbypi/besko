class AddPackagesReceiptIdColumn < ActiveRecord::Migration
  def change
    add_column :packages, :receipt_id, :integer
    add_index :packages, :receipt_id
  end
end
