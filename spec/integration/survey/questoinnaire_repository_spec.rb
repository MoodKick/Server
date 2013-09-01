require 'spec_helper'

include Survey
describe QuestionnaireRepository do
  before do
    repository.delete_all
  end
  let(:repository) { QuestionnaireRepository.new }
  let(:title) { 'Sample title' }

  describe '#add' do
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

    describe 'persists questionnaire with related questions' do
      before do
        repository.add(questionnaire)
      end

      subject { found_questionnaire }
      let(:found_questionnaire) { repository.find(questionnaire.id) }
      its(:title) { should == title }

      describe 'questions' do
        describe 'measurable question' do
          subject { found_questionnaire.questions[0] }
          its(:description) { should == measurable_question.description }
          its(:unit) { should == unit }
        end
        describe 'single choice question' do
          subject { found_questionnaire.questions[1] }
          its(:description) { should == single_choice_question.description }
          its(:choices) { should == single_choice_question.choices }
        end
      end
    end
  end

end
