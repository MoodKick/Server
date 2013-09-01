class AddLaunchNumberToContentObjects < ActiveRecord::Migration
  def change
    add_column :content_objects, :launch_number, :integer, default: 0
  end
end
