class AddTypeToContentObjects < ActiveRecord::Migration
  def change
    add_column :content_objects, :type, :string
  end
end
