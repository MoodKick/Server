class CreateDailyReports < ActiveRecord::Migration
  def change
    create_table :daily_reports do |t|
      t.string :name
      t.text :description
      t.boolean :calm
      t.boolean :angry
      t.boolean :anxious
      t.boolean :manic
      t.integer :happiness_level
      t.integer :user_id

      t.timestamps
    end
  end
end
