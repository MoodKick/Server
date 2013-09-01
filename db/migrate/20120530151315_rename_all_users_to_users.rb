class RenameAllUsersToUsers < ActiveRecord::Migration
  def up
    rename_table :all_users, :users
  end

  def down
    rename_table :users, :all_users
  end
end
