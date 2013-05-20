class CreateForwardingAddresses < ActiveRecord::Migration
  def change
    create_table :forwarding_addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.references :user

      t.timestamps
    end
    add_index :forwarding_addresses, :user_id
  end
end
