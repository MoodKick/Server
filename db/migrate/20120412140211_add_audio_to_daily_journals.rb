class AddAudioToDailyJournals < ActiveRecord::Migration
  def change
    add_column :daily_journals, :audio, :string
  end
end
