class AddUserActivatedAtColumn < ActiveRecord::Migration
  def change
    add_column :users, :activated_at, :datetime
    add_index :users, :activated_at
  end
end
