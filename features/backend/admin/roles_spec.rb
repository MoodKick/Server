require_relative '../acceptance_helper'

feature 'Manage users\' roles', %q{
  As an admin
  I want to manage users' roles
} do
  before do
    @admin = registration_service.register_admin(FactoryGirl.attributes_for(:admin))
    @user = registration_service.register_user(FactoryGirl.attributes_for(:user))
    @therapist = registration_service.register_therapist(FactoryGirl.attributes_for(:therapist))
    sign_in_admin!(@admin)
  end

  scenario 'Edit' do
    visit backend_admin_user_path(@user)
    click_link 'Edit roles'
    page.should have_css('h2', text: 'Roles')
    page.should have_css('li', text: 'Therapist Add')
    page.should have_css('li', text: 'Relative Add')
    page.should have_css('li', text: 'Client Add')
    page.should have_css('li', text: 'Admin Add')
  end

  scenario 'Navigation' do
    visit backend_admin_user_roles_path(@user)
    click_link('Back')
    page.should have_css('h2', text: 'User')
    page.should have_content(@user.email)
  end

  scenario 'Add role' do
    visit backend_admin_user_roles_path(@user)
    within('li', text: 'Therapist Add') do
      click_link('Add')
    end
    page.should have_content('Successfully added role.')
    page.should have_content('Therapist Remove')
    page.should_not have_content('Therapist Add')
  end

  scenario 'Remove role' do
    visit backend_admin_user_roles_path(@therapist)
    within('li', text: 'Therapist Remove') do
      click_link('Remove')
    end

    page.should have_content('Successfully removed role.')
    page.should have_content('Therapist Add')
    page.should_not have_content('Therapist Remove')
  end
end
