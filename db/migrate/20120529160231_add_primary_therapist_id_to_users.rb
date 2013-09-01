class AddPrimaryTherapistIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :primary_therapist_id, :integer
  end
end
