class AddQuestionnaire < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.string :title
    end

    create_table :questions do |t|
      t.integer :questionnaire_id
      t.integer :position
      t.string :description
      t.text :choices
      t.integer :value
      t.text :unit
      t.string :type
    end

    create_table :answer_groups do |t|
      t.integer :questionnaire_id
      t.integer :user_id
    end

    create_table :answers do |t|
      t.integer :answer_group_id
      t.integer :question_id
      t.string :type
      t.integer :value
    end
  end
end
