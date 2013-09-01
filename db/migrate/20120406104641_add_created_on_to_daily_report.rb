class AddCreatedOnToDailyReport < ActiveRecord::Migration
  def change
    add_column :daily_reports, :created_on, :date
  end
end
