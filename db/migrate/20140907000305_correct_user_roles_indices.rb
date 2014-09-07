class CorrectUserRolesIndices < ActiveRecord::Migration
  def change
    remove_index :user_roles, name: :index_user_roles_on_role_id_and_user_id
    remove_index :user_roles, name: :index_user_roles_on_user_id_and_role_id
    add_index :user_roles, [:user_id, :title], unique: true
  end
end
