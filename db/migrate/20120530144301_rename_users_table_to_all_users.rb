class RenameUsersTableToAllUsers < ActiveRecord::Migration
  def up
    rename_table :users, :all_users
  end

  def down
    rename_table :all_users, :users
  end
end
