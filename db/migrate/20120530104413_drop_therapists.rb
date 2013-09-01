class DropTherapists < ActiveRecord::Migration
  def up
    drop_table :therapists
  end

  def down
  end
end
