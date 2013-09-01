require_relative '../acceptance_helper'

feature 'Safety plans', %q{
  As a Therapist,
  I want to be able to create and manage a Safety Plan
  for each of my Clients
} do

  before do
    @therapist = registration_service.register_therapist(
      FactoryGirl.attributes_for(:therapist))
    @client = registration_service.register_client(
      FactoryGirl.attributes_for(:client, full_name: 'Client'))

    @therapist.add_client(@client)
    @therapist.save

    sign_in_therapist!(@therapist)
  end

  scenario 'Show' do
    visit "/backend/therapist/clients/#{@client.id}"
    click_link 'Safety plan'
    page.should have_css('h2', text: 'Safety plan')
  end

  scenario 'Edit' do
    visit "/backend/therapist/clients/#{@client.id}/safety_plan"
    click_link 'Edit'
    page.should have_css('h2', text: 'Edit safety plan')
    #FIXME: wysihtml5 hides original textarea thus we cannot
    # fill it in
    #fill_in 'safety_plan[body]', with: 'Safety plan1'
    click_button 'Update Safety plan'
    page.should have_css('h2', text: 'Safety plan')
    #page.should have_content('Safety plan1')
  end
end
