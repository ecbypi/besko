class DropRolesTable < ActiveRecord::Migration
  def up
    drop_table :roles

    remove_column :user_roles, :role_id
    add_column :user_roles, :title, :string
  end

  def down
    remove_column :user_roles, :title
    add_column :user_roles, :role_id, :integer

    create_table :roles do |t|
      t.string :type
      t.columns
    end
  end
end
