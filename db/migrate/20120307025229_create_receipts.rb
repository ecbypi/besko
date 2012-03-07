class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.text :comment
      t.references :delivery
      t.references :recipient

      t.timestamps
    end
    add_index :receipts, :delivery_id
    add_index :receipts, :recipient_id
  end
end
