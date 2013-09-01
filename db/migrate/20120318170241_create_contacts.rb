class CreateContacts < ActiveRecord::Migration
  def change
    create_table(:contacts) do |t|
      t.integer :owner_id
      t.integer :user_id
      t.timestamps
    end
  end
end
