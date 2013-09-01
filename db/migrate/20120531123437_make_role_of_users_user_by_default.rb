class MakeRoleOfUsersUserByDefault < ActiveRecord::Migration
  def up
    change_column :users, :role, :string, default: 'User'
  end

  def down
    change_column :users, :role, :string, default: nil
  end
end
