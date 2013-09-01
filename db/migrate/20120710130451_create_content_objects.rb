class CreateContentObjects < ActiveRecord::Migration
  def change
    create_table :content_objects do |t|
      t.string :title
      t.string :name
      t.string :author
      t.text :description
      t.text :data

      t.timestamps
    end
  end
end
