class AddNameToTherapists < ActiveRecord::Migration
  def change
    add_column :therapists, :name, :string
  end
end
