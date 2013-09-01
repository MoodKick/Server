require_relative '../acceptance_helper'

feature 'Content Objects', %q{
  As an Administrator,
  I want to be able to perform a Content Object Scan
  in order to have the system discover available COs
  for the Users to see
} do

  before do
    @admin = registration_service.register_admin(FactoryGirl.attributes_for(:admin))
    sign_in_admin!(@admin)
  end

  scenario 'List' do
    rep = ContentObjectRepository.new
    cob1, cob2 = (1..2).map { FactoryGirl.build(:content_object) }
    rep.add(cob1)
    rep.add(cob2)
    2.times { rep.increase_launch_number(cob1.id) }
    rep.increase_launch_number(cob2.id)

    click_link('Admin')
    click_link('Content objects')

    page.should have_css('h2', 'Content objects')
    within("tbody tr:nth-child(1)") do
      page.should have_content(cob1.title)
      page.should have_css('td:nth-child(2)', text: '2')
    end
    within("tbody tr:nth-child(2)") do
      page.should have_content(cob2.title)
      page.should have_css('td:nth-child(2)', text: '1')
    end
  end

  scenario 'Update all' do
    visit backend_admin_content_objects_path
    click_link 'Update all'
    page.should have_content('title1')
    page.should have_content('title2')
  end

  scenario 'Show' do
    cob1 = FactoryGirl.create(:content_object)
    visit backend_admin_content_objects_path
    click_link cob1.title

    page.should have_content cob1.title
    page.should have_content cob1.description
    page.should have_content cob1.author
    page.should have_content cob1.name
  end
end
