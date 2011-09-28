class RenamePackageReceivedColumn < ActiveRecord::Migration
  def up
    rename_column :packages, :received, :received_on
  end

  def down
    rename_column :packages, :received_on, :received
  end
end
