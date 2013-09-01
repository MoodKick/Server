require 'spec_helper'

include Survey
describe AnswerGroupRepository do
  before do
    repository.delete_all
  end

  let(:repository) { AnswerGroupRepository.new }

  describe '#for_client_by_questionnaire_id' do
    context 'when there are a few results for given client
             and questionnaire' do
      let(:group1) {
        Survey::AnswerGroup.new(questionnaire_id: 1, user_id: 10)
      }
      let(:group2) {
        Survey::AnswerGroup.new(questionnaire_id: 1, user_id: 10)
      }
      let(:group3) {
        Survey::AnswerGroup.new(questionnaire_id: 1, user_id: 11)
      }
      before do
        repository.add(group1)
        repository.add(group2)
        repository.add(group3)
      end

      it 'returns them' do
        repository.for_client_by_questionnaire_id(10, 1).should ==
          [group1, group2]
      end
    end
  end

  describe '#for_questionnaire_id_and_client_ids' do
    context 'when there are a few results for given questionnaire' do
      let(:group1) { Survey::AnswerGroup.new(questionnaire_id: 1, user_id: 1) }
      let(:group2) { Survey::AnswerGroup.new(questionnaire_id: 1, user_id: 2) }
      let(:group3) { Survey::AnswerGroup.new(questionnaire_id: 2, user_id: 3) }

      before do
        repository.add(group1)
        repository.add(group2)
        repository.add(group3)
      end

      it 'returns them' do
        repository.for_questionnaire_id_and_client_ids(1, [1, 3]).should == [group1]
      end
    end
  end

  describe '#add' do
    context 'when there is already a questionnaire and a user' do
      let(:title) { 'Sample title' }

      let(:questionnaire_repository) { QuestionnaireRepository.new }

      ####
      let(:unit) do
        Unit.new(min_value: 1, max_value: 5, min_value_description: 'Min',
                 max_value_description: 'Max')
      end

      let(:measurable_question) do
        MeasurableQuestion.new(description: 'desc1', unit: unit)
      end

      let(:single_choice_question) do
        res = SingleChoiceQuestion.new(description: 'desc2')
        res.add_choice(Choice.new(id: 1, value: 'v1'))
        res.add_choice(Choice.new(id: 2, value: 'v2'))
        res
      end

      let(:questionnaire) do
        res = Questionnaire.new(title: title)
        res.add_question(1, measurable_question)
        res.add_question(2, single_choice_question)
        res
      end
      ######

      let(:user) { FactoryGirl.build(:user) }

      before do
        user.save
        questionnaire_repository.add(questionnaire)
      end

      describe 'persists answer group with related answers' do
        let(:answer_group) do
          res = AnswerGroup.new
          res.questionnaire = questionnaire
          res.user = user

          level_of_stress_answer = MeasurableAnswer.new({
            value: 2, question: measurable_question })

          psychological_pain_answer = SingleChoiceAnswer.new({
            value: 1, question: single_choice_question })

          res.add_answer(level_of_stress_answer)
          res.add_answer(psychological_pain_answer)
          res
        end

        before do
          repository.add(answer_group)
        end

        subject { found_answer_group }
        let(:found_answer_group) { repository.find(answer_group.id) }
        its(:user) { should == user }

        its(:id) { should_not be_blank }

        describe 'answers' do
          describe 'measurable answer' do
            subject { found_answer_group.answers[0] }
            its(:value) { should == 2 }
            its(:question) { should == measurable_question }
          end

          describe 'singel choice answer' do
            subject { found_answer_group.answers[1] }
            its(:value) { should == 1 }
            its(:question) { should == single_choice_question }
          end
        end
      end
    end
  end
end
