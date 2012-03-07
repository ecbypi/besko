class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.string :deliverer
      t.references :worker

      t.timestamps
    end

    add_index :deliveries, :worker_id
  end
end
