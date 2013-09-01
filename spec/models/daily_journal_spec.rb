require_relative '../spec_helper'

describe 'DailyJournal' do
  it 'has keywords' do
    daily_journal = FactoryGirl.build(:daily_journal, angry: true, calm: true)
    daily_journal.keywords.should == ['Calm', 'Angry']
  end

  it 'has audio' do
    daily_journal = FactoryGirl.build(:daily_journal)
    daily_journal.has_audio?.should be_false
    daily_journal.audio = File.open(Rails.root.to_s + "/features/fixtures/test_audio.wav")
    daily_journal.has_audio?.should be_true
  end

  it 'has video' do
    daily_journal = FactoryGirl.build(:daily_journal)
    daily_journal.has_video?.should be_false
    daily_journal.video = File.open(Rails.root.to_s + "/features/fixtures/test_video.3gpp")
    daily_journal.has_video?.should be_true
  end
end
