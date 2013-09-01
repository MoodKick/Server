class MultipleRoles < ActiveRecord::Migration
  def up
    remove_column :users, :role
    add_column :users, :roles, :string
  end

  def down
    remove_column :users, :roles
    add_column :users, :role, :string
  end
end
