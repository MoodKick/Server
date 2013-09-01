class AddCreatedAtToAnswerGroup < ActiveRecord::Migration
  def change
    add_column :answer_groups, :created_at, :datetime
  end
end
