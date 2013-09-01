class DropRoles < ActiveRecord::Migration
  def up
    drop_table(:roles)
    drop_table(:users_roles)
  end
end
