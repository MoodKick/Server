class ChangeTherapistsRolesToUserRoles < ActiveRecord::Migration
  def up
    drop_table(:therapists_roles)
    create_table(:users_roles, id: false) do |t|
      t.references :user
      t.references :role
    end

    add_index(:users_roles, [ :user_id, :role_id ])
  end

  def down
  end
end
