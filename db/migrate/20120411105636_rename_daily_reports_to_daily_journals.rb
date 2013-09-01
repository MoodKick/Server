class RenameDailyReportsToDailyJournals < ActiveRecord::Migration
  def up
    rename_table :daily_reports, :daily_journals
  end

  def down
    rename_table :daily_journals, :daily_reports
  end
end
