class AddVideoToDailyJournal < ActiveRecord::Migration
  def change
    add_column :daily_journals, :video, :string
  end
end
