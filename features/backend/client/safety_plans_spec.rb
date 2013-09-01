require_relative '../acceptance_helper'

feature 'Safety plans', %q{
} do
  let(:safety_plan_body) {
    'Hello, I am safety plan'
  }
  before do
    client = registration_service.register_client(
      FactoryGirl.attributes_for(:client))
    therapist = registration_service.register_therapist(
      FactoryGirl.attributes_for(:therapist))
    therapist.add_client(client)
    therapist.save

    service = SafetyPlanService.new(SafetyPlanRepository.new)
    service.create({ body: safety_plan_body }, client.id, therapist)

    sign_in_client!(client)
  end

  scenario 'Show' do
    visit '/backend'
    click_link 'Client'
    click_link 'Safety plan'
    page.should have_css('h2', text: 'Safety plan')
    page.should have_content(safety_plan_body)
  end
end
