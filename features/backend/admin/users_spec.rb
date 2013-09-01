require_relative '../acceptance_helper'

feature 'Manage users', %q{
  As an admin
  I want to manage users
} do

  before do
    @admin = registration_service.register_admin(FactoryGirl.attributes_for(:admin))
    @client = registration_service.register_client(FactoryGirl.attributes_for(:client))
    @therapist = registration_service.register_therapist(FactoryGirl.attributes_for(:therapist))
    @relative = registration_service.register_relative(FactoryGirl.attributes_for(:relative))
    @user = registration_service.register_user(FactoryGirl.attributes_for(:user))
    @users = [@admin, @client, @therapist, @relative, @user]
    sign_in_admin!(@admin)
  end

  scenario 'List' do
    click_link 'Admin'
    click_link 'Users'
    page.should have_css('h2', 'Users')
    @users.each do |user|
      page.should have_content(user.full_name)
    end
  end

  scenario 'Show' do
    visit backend_admin_users_path
    click_link @therapist.full_name
    page.should have_css('h2', text: 'User')
    page.should have_content @therapist.full_name
    page.should have_content @therapist.email
    page.should have_content @therapist.location
    page.should have_content @therapist.description
    page.should have_content 'Therapist'

    page.should have_content 'Edit'
  end

  scenario 'Create' do
    visit backend_admin_users_path
    click_link 'Add user'
    page.should have_css('h2', text: 'New User')
    fill_in 'Username', with: 'tpb'
    fill_in 'Full name', with: 'Thomas Peter'
    fill_in 'Email', with: 'someemail@mail.com'
    select 'Hovedstaden', from: 'Location'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Add User'
    page.should have_content('User was successfully added.')
    page.should have_content('Thomas Peter')
    page.should have_content('tpb')
    page.should have_content('Hovedstaden')
    page.should have_content('someemail@mail.com')
  end

  scenario 'Edit' do
    visit backend_admin_user_path(@therapist)
    click_link 'Edit'
    page.should have_css('h2', text: 'Edit User')
    fill_in 'Full name', with: 'New name'
    fill_in 'Email', with: 'new_email@example.com'
    click_button 'Update User'
    page.should have_content('User was successfully updated.')
    page.should have_content('New name')
    page.should have_content('new_email@example.com')
  end

  describe 'Associate therapist and a client' do
    scenario 'Is shown for therapists only' do
      #TODO: move this to unit test
      (@users - [@therapist]).each do |user|
        visit backend_admin_user_path(@user)
        page.should_not have_content('Associate client')
      end
    end

    scenario 'Associate therapist and a client' do
      visit backend_admin_user_path(@therapist)
      click_link 'Associate client'
      page.should have_css('h2', text: 'Associate')
      fill_in 'Client', with: @client.id
      click_button 'Associate'
      page.should have_content('Client was successfully associated')
    end
  end

  scenario 'Delete' do
    visit backend_admin_user_path(@therapist)
    click_link 'Delete'
    page.driver.browser.switch_to.alert.accept
    page.should have_content('Successfully deleted user.')
    page.should have_css('h2', text: 'Users')
    page.should_not have_content(@therapist.full_name)
  end
end
