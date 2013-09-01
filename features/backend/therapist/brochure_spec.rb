require_relative '../acceptance_helper'

feature 'Brochure', %q{
  As a Therapist,
  I want to be able to create and manage
  Help and Learn sections
} do

  def brochure_service
    BrochureService.new(BrochureRepository.new)
  end

  before do
    @therapist = registration_service.register_therapist(
      FactoryGirl.attributes_for(:therapist))
    sign_in_therapist!(@therapist)
  end
  let(:help_body) { 'I am the help brochure' }

  scenario 'Show' do
    brochure_service.update_help(help_body)

    click_link 'Therapist'
    click_link 'Brochures'
    click_link 'Help brochure'

    page.should have_css('h2', text: 'Help brochure')
    page.should have_content(help_body)
  end

  scenario 'Edit' do
    brochure_service.update_help(help_body)

    visit '/backend/therapist/brochures/help'

    click_link 'Edit'
    page.should have_css('h2', text: 'Edit Help brochure')
    #FIXME: wysihtml5 hides original textarea, thus we cannot
    # fill it in
    #fill_in 'brochure[body]', with: 'New body'
    click_button 'Update Brochure'

    page.should have_css('h2', 'Help brochure')
    #page.should have_content('New body')
  end

end
