class CreateBrochures < ActiveRecord::Migration
  def change
    create_table :brochures do |t|
      t.string :type
      t.text :body, default: ''

      t.timestamps
    end
  end
end
