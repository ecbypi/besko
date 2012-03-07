class DropPackagesTable < ActiveRecord::Migration
  def up
    drop_table :packages
  end

  def down
  end
end
