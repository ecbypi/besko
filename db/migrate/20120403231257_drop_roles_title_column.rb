class DropRolesTitleColumn < ActiveRecord::Migration
  def up
    remove_column :roles, :title
  end

  def down
    add_column :roles, :title, :string
  end
end
