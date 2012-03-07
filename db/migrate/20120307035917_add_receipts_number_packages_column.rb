class AddReceiptsNumberPackagesColumn < ActiveRecord::Migration
  def change
    add_column :receipts, :number_packages, :integer
    add_column :receipts, :signed_out_at, :datetime
  end
end
