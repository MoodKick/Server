require_relative '../acceptance_helper'

feature 'Survey', %q{
} do
  before do
    @therapist = registration_service.register_therapist(
      FactoryGirl.attributes_for(:therapist))
    sign_in_therapist!(@therapist)

    @client1 = registration_service.register_client(
      FactoryGirl.attributes_for(:client))

    @client2 = registration_service.register_client(
      FactoryGirl.attributes_for(:client))
    therapist_service.make_primary_therapist(@client1.id, @therapist.id)
    therapist_service.make_primary_therapist(@client2.id, @therapist.id)
  end

  let(:repository) { Survey::QuestionnaireRepository.new }
  let(:answer_group_repository) { Survey::AnswerGroupRepository.new }
  let(:survey_service) {
    Survey::SurveyService.new(repository, answer_group_repository)
  }
  let(:therapist_service) {
    TherapistService.new(ServiceContainer.party_repository)
  }

  context 'when there are 2 questionnaires' do
    let(:text_question1) do
      Survey::TextQuestion.new({ description: 'Text question1' })
    end

    let(:text_question2) do
      Survey::TextQuestion.new({ description: 'Text question2' })
    end

    let(:questionnaire1) do
      questionnaire = Survey::Questionnaire.new(title: 'Questionnaire1')
      questionnaire.add_question(1, text_question1)
      questionnaire
    end

    let(:questionnaire2) do
      questionnaire = Survey::Questionnaire.new(title: 'Questionnaire2')
      questionnaire.add_question(1, text_question2)
      questionnaire
    end

    before do
      repository.add(questionnaire1)
      repository.add(questionnaire2)
    end

    scenario 'List questionnaires for client' do
      visit "/backend/therapist/clients/#{@client1.id}"
      click_link 'Questionnaire Results'
      page.should have_css('h2', text: 'Questionnaires')
      page.should have_content('Questionnaire1')
      page.should have_content('Questionnaire2')
    end

    scenario 'List all questionnaires' do
      click_link 'Therapist'
      click_link 'Questionnaires'
      page.should have_css('h2', text: 'Questionnaires')
      page.should have_content('Questionnaire1')
      page.should have_content('Questionnaire2')
    end

    context 'when there are 2 Questionnaire results for client1 and 1 Questionnaire result for client2' do
      before do
        @answer_group1 = survey_service.answer(@client1.id, questionnaire1.id, {
          '1' => { 'text' => 'text1' }
        })
        @answer_group2 = survey_service.answer(@client1.id, questionnaire1.id, {
          '1' => { 'text' => 'text2' }
        })
        @answer_group3 = survey_service.answer(@client2.id, questionnaire1.id, {
          '1' => { 'text' => 'text3' }
        })
      end

      context 'For client' do
        scenario 'Show Questionnaire Results for Questionnaire' do
          visit "/backend/therapist/clients/#{@client1.id}/questionnaires"
          click_link 'Questionnaire1'
          page.should have_css('h2', text: 'Questionnaire Results for Questionnaire1')
          page.should have_content('text1')
          page.should have_content(@answer_group1.created_at.to_s)
          page.should have_content('text2')
          page.should have_content(@answer_group2.created_at.to_s)
          page.should_not have_content('text3')
        end

        scenario 'Show detailed Questionnaire Results' do
          visit "/backend/therapist/clients/#{@client1.id}/questionnaires/#{questionnaire1.id}/results"
          within(:xpath, '//table/tbody') do
            within(:xpath, './/tr[1]') do
              click_link 'Details'
            end
          end
          should_be_on_questionnaire_result_page(@answer_group1.id)
        end
      end

      def should_be_on_questionnaire_result_page(answer_group_id)
        #we cannot check current path, since the page may not be loaded yet. Thus wait for dom
        page.should have_css('h2', 'Questionnaire Result')
        current_path.should == "/backend/therapist/questionnaire_results/#{answer_group_id}"
      end

      scenario 'Show Detailed Questionnaire Result' do
        visit "/backend/therapist/questionnaire_results/#{@answer_group1.id}"

        page.should have_css('h2', text: 'Questionnaire Result')
        page.should have_content('text1')
        page.should have_content(@answer_group1.created_at.to_s)
      end

      context 'For questionnaire' do
        scenario 'Show Questionnaire Results for Questionnaire' do
          visit '/backend/therapist/questionnaires'
          click_link 'Questionnaire1'
          page.should have_css('h2', text: 'Questionnaire Results for Questionnaire1')
          within(:xpath, '//table/tbody') do
            within(:xpath, './/tr[1]') do
              page.should have_content('text1')
              page.should have_content(@answer_group1.created_at.to_s)
              page.should have_content(@client1.username)
            end
            within(:xpath, './/tr[2]') do
              page.should have_content('text2')
              page.should have_content(@answer_group2.created_at.to_s)
              page.should have_content(@client1.username)
            end
            within(:xpath, './/tr[3]') do
              page.should have_content('text3')
              page.should have_content(@answer_group3.created_at.to_s)
              page.should have_content(@client2.username)
            end
          end
        end

        scenario 'Show detailed Questionnaire Results', focus: true do
          visit "/backend/therapist/questionnaires/#{questionnaire1.id}/results"
          within(:xpath, '//table/tbody/tr[1]') do
            click_link 'Details'
          end
          should_be_on_questionnaire_result_page(@answer_group1.id)
        end
      end
    end
  end
end
