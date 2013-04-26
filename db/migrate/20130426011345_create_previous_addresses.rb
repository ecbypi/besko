class CreatePreviousAddresses < ActiveRecord::Migration
  def change
    create_table :previous_addresses do |t|
      t.string :address
      t.references :user
      t.references :preceded_by

      t.timestamps
    end
    add_index :previous_addresses, :user_id
    add_index :previous_addresses, :preceded_by_id
  end
end
