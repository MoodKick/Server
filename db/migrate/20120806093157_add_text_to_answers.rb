class AddTextToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :text, :string
    add_column :answers, :choice_id, :integer
    add_column :answers, :choice_ids, :text
  end
end
