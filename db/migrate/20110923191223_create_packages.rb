class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.references :worker
      t.references :recipient
      t.string :delivered_by
      t.text :comment
      t.date :received
      t.datetime :signed_out_at

      t.timestamps
    end
    add_index :packages, :worker_id
    add_index :packages, :recipient_id
  end
end
