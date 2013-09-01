require_relative 'acceptance_helper'

feature 'Signing in', %q{
} do

  describe 'Sign in by accessing sign in page' do
    let(:client) do
      registration_service.register_client(
        FactoryGirl.attributes_for(:client))
    end

    scenario 'as a client' do
      sign_in_client!(client)
      page.should have_content('Signed in successfully.')
      page.should have_content('Client')
    end
  end

  describe 'Not signed in users should not see navigation' do
    before do
      visit '/backend'
    end

    subject { page }
    ['Client'].each do |menu_item_text|
      it { should_not have_css('ul.nav li a', text: menu_item_text) }
    end
  end
end
