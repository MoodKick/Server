class CreateSafetyPlans < ActiveRecord::Migration
  def change
    create_table :safety_plans do |t|
      t.integer :client_id
      t.integer :created_by
      t.text :body

      t.timestamps
    end
  end
end
