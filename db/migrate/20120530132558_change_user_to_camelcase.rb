class ChangeUserToCamelcase < ActiveRecord::Migration
  def up
    execute "UPDATE users SET role = 'User' WHERE role='user'"
  end

  def down
  end
end
