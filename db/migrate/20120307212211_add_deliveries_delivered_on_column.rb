class AddDeliveriesDeliveredOnColumn < ActiveRecord::Migration
  def change
    add_column :deliveries, :delivered_on, :date
    add_index :deliveries, :delivered_on
  end
end
