require_relative '../acceptance_helper'

feature 'Chest of hope', %q{
  As a Client I want to be able to manage my Chest of Hope
  to be able to enter a safe and comfortable space with
  positive and affirming thoughts to counter emerging suicidal thoughts.
} do
  let(:client) do
    registration_service.register_client(
      FactoryGirl.attributes_for(:client))
  end

  before do
    sign_in_client!(client)
  end

  context 'when there are a few hope items' do
    let(:hope_item_repository) { HopeItemRepository.new }
    let(:chest_of_hope_service) do
      ClientChestOfHopeService.new(hope_item_repository)
    end

    before do
      ['item1', 'item2'].each do |title|
        chest_of_hope_service.add_hope_item(client, title)
      end
    end

    scenario 'List' do
      visit '/backend'
      click_link 'Client'
      click_link 'Chest of hope'
      page.should have_css('h2', text: 'Chest of hope')
      page.should have_content('item1')
      page.should have_content('item2')
    end

    scenario 'Delete' do
      visit '/backend/client/hope_items'
      within(:xpath, "//tr[contains(.,'item1')]") do
        click_link 'Destroy'
        page.driver.browser.switch_to.alert.accept
      end
      page.should have_content('Successfully removed hope item.')
      page.should_not have_content('item1')
    end

    scenario 'Edit' do
      visit '/backend/client/hope_items'
      within(:xpath, "//tr[contains(.,'item1')]") do
        click_link 'Edit'
      end
      page.should have_css('h2', 'Edit hope item')
      fill_in 'hope_item[title]', with: 'New title'
      fill_in 'hope_item[text]', with: 'New text'
      click_button 'Update Hope item'
      page.should have_content('Successfully updated hope item.')
      page.should have_content('New title')
    end
  end

  context 'Add' do
    before do
      visit '/backend/client/hope_items'
    end

    scenario 'Add text' do
      click_link 'Add text'
      page.should have_css('h2', text: 'New hope item')
      fill_in 'hope_item[title]', with: 'title1'
      fill_in 'hope_item[text]', with: 'Text1'
      click_button 'Create Hope item'
      page.should have_content('Successfully added hope item.')
      page.should have_content('title1')
      page.should have_content('text')
    end
  end
end
