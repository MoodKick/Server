class ChangeRoleToClient < ActiveRecord::Migration
  def up
    execute "UPDATE users SET role = 'Client' WHERE role='User'"
  end

  def down
    execute "UPDATE users SET role = 'User' WHERE role='Client'"
  end
end
