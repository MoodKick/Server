require_relative '../acceptance_helper'

feature 'View clients', %q{
  In order to help my clients
  As a therapist
  I want to see information about them
} do

  before do
    @therapist = registration_service.register_therapist(
      FactoryGirl.attributes_for(:therapist))
    @client = registration_service.register_client(
      FactoryGirl.attributes_for(:client, full_name: 'Client1'))
    @client2 = registration_service.register_client(
      FactoryGirl.attributes_for(:client, full_name: 'Client2'))
    @therapist.add_client(@client)
    @therapist.add_client(@client2)
    @therapist.save

    sign_in_therapist!(@therapist)
  end

  scenario 'List' do
    visit '/backend'
    click_link 'Therapist'
    click_link 'Clients'
    [@client, @client2].each do |client|
      page.should have_content(client.full_name)
      page.should have_content(client.username)
      page.should have_content(client.avatar_url)
      page.should have_content(client.location)
      page.should have_content('Client')
    end
  end

  scenario 'Detailed view' do
    visit '/backend/therapist/clients'
    click_link @client.full_name
    page.should have_content(@client.full_name)
    page.should have_content(@client.username)
    page.should have_content(@client.avatar_url)
    page.should have_content(@client.location)
    page.should have_content('Client')
  end
end
