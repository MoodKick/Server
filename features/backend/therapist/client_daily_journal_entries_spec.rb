require_relative '../acceptance_helper'

feature 'Client daily journal entries', %q{
  As a Therapist,
  I want to be able to see the Daily Journal of each of my clients,
  so that I may know of the progress made by each Client
} do
  before do
    therapist = registration_service.register_therapist(
      FactoryGirl.attributes_for(:therapist))
    @client = registration_service.register_client(
      FactoryGirl.attributes_for(:client))
    @daily_journal_entry = FactoryGirl.build(:daily_journal,
      angry: true,
      anxious: true,
      calm: false,
      happiness_level: 3,
      created_at: "2012-04-21 11:34:16 UTC",
      name: 'Awesome day!',
      description: 'Well, it was fun')
    @daily_journal_entry.audio = File.open("#{Rails.root}/features/fixtures/test_audio.wav")
    @daily_journal_entry.video = File.open("#{Rails.root}/features/fixtures/test_video.3gpp")
    @daily_journal_entry_without_media = FactoryGirl.build(:daily_journal,
      manic: true,
      calm: true,
      happiness_level: 4,
      created_at: "2011-02-05 11:34:16 UTC")
    @client.add_daily_journal_entry(@daily_journal_entry)
    @client.add_daily_journal_entry(@daily_journal_entry_without_media)

    therapist.add_client(@client)
    therapist.save

    sign_in_therapist!(therapist)
  end

  scenario 'Listing' do
    visit "/backend/therapist/clients/#{@client.id}"
    click_link 'Daily journal'
    within(:xpath, '//table/tbody') do
      within(:xpath, './/tr[1]') do
        page.should have_content('5/2')
        page.should have_content('Manic')
        page.should have_content('Calm')
        page.should have_content('4')
      end
      within(:xpath, './/tr[2]') do
        page.should have_content('21/4')
        page.should have_content('Angry')
        page.should have_content('Anxious')
        page.should have_content('3')
      end
    end

  end

  describe 'Detailed view' do
    it 'shows information, with links to audio and video' do
      visit "/backend/therapist/clients/#{@client.id}/daily_journal_entries"
      click_link '21/4'
      page.should have_css('h2', 'Daily journal entry')
      page.should have_css('.happiness-level', '3')
      within('.keywords') do
        page.should have_content('Angry')
        page.should have_content('Anxious')
        page.should_not have_content('Calm')
        page.should_not have_content('Manic')
      end
      page.should have_css('.created-at', '21/4')
      page.should have_css('.name', 'Awesome day!')
      page.should have_css('.description', 'Well, it was fun')
      within('.audio') do
        page.should have_link('Play', href: "/backend/therapist/clients/#{@client.id}/daily_journal_entries/#{@daily_journal_entry.id}/audio")
      end
      within('.video') do
        page.should have_link('Play', href: "/backend/therapist/clients/#{@client.id}/daily_journal_entries/#{@daily_journal_entry.id}/video")
      end
    end

    it 'tells that there is no audio or video if it is not present' do
      visit "/backend/therapist/clients/#{@client.id}/daily_journal_entries/#{@daily_journal_entry_without_media.id}"
      within('.audio') do
        page.should_not have_link('Play')
        page.should have_content('No audio')
      end
      within('.video') do
        page.should_not have_link('Play')
        page.should have_content('No video')
      end
    end
  end

end
