require_relative '../acceptance_helper'
require_relative '../../../spec/daily_journal_entries_generator'

feature 'Client mood trend', %q{
  As a Therapist,
  I want to be able to view the Mood Trends of each of my Clients,
  so that I may follow their progress
} do
  before do
    therapist = registration_service.register_therapist(
      FactoryGirl.attributes_for(:therapist))
    @client = registration_service.register_client(
      FactoryGirl.attributes_for(:client))

    therapist.add_client(@client)
    therapist.save
    Timecop.travel(Time.local(2012, 6, 1, 12, 0, 0))
    MoodKick::Test::DailyJournalEntriesGenerator.generate(@client)
    sign_in_therapist!(therapist)
  end

  scenario 'Detailed view' do
    visit "/backend/therapist/clients/#{@client.id}"
    click_link 'Mood trend'
    page.should have_css('h2', 'Mood trend')
    within('.range-selector') do
      page.should have_content('2/5')
      page.should have_content('1/6')
      page.should have_content('30 days')
    end
    within('.days-marked-with') do
      page.should have_css('.calmness', '5')
      page.should have_css('.anger', '7')
      page.should have_css('.mania', '40')
      page.should have_css('.anxiety', '21')
    end

    within('.good-and-bad') do
      best_day = find(:css, '.best-day td').text
      expect { Date.parse(best_day) }.to_not raise_error(ArgumentError)
      worst_day = find(:css, '.worst-day td').text
      expect { Date.parse(worst_day) }.to_not raise_error(ArgumentError)
    end
  end
end
