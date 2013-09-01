class AddHopeItems < ActiveRecord::Migration
  def change
    create_table :hope_items do |t|
      t.integer :client_id
      t.string :title
      t.string :type
      t.text :text
      t.string :url
    end
  end
end
