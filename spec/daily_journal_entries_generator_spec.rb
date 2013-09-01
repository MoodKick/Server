require_relative 'spec_helper'
require_relative 'daily_journal_entries_generator'

include MoodKick::Test
describe DailyJournalEntriesGenerator do
  let(:client) { FactoryGirl.create(:user) }
  before do
    DailyJournalEntriesGenerator.generate(client)
  end

  it 'generates 40 entries for client' do
    client.daily_journal_entries.count.should == 40
  end

  it 'generates exactly 5 Calm days' do
    client.daily_journal_entries.where(calm: true).count.should == 5
  end

  it 'generates exactly 7 Angry days' do
    client.daily_journal_entries.where(angry: true).count.should == 7
  end

  it 'generates exactly 21 anxious days' do
    client.daily_journal_entries.where(anxious: true).count.should == 21
  end

  it 'generates exactly 40 manic days' do
    client.daily_journal_entries.where(manic: true).count.should == 40
  end
end
