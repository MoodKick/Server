require 'spec_helper'

include Survey

describe 'SurveyService' do
  let(:repository) { QuestionnaireRepository.new }
  let(:answer_group_repository) { AnswerGroupRepository.new }
  let(:service) { SurveyService.new(repository, answer_group_repository) }

  let(:name_day_question) do
    TextQuestion.new({ description: 'Name the day' })
  end

  let(:taking_life_question) do
    res = SingleChoiceQuestion.new({
      description: 'I have thoughts of taking my own life' })
    res.add_choice(Choice.new(id: 1, value: 'Never'))
    res.add_choice(Choice.new(id: 2, value: 'Seldom'))
    res.add_choice(Choice.new(id: 3, value: 'Sometimes'))
    res.add_choice(Choice.new(id: 4, value: 'Often'))
    res.add_choice(Choice.new(id: 5, value: 'Very often'))
    res
  end
  let(:keywords_question) do
    res = MultipleChoiceQuestion.new({ description: 'Keywords' })
    res.add_choice(Choice.new(id: 1, value: 'Calm'))
    res.add_choice(Choice.new(id: 2, value: 'Angry'))
    res.add_choice(Choice.new(id: 3, value: 'Anxious'))
    res.add_choice(Choice.new(id: 4, value: 'Manic'))
    res
  end
  let(:level_of_stress_question) do
    level_of_stress_unit = Unit.new({
      min_value: 1,
      max_value: 5,
      min_value_description: 'Low',
      max_value_description: 'High' })
    level_of_stress_question = MeasurableQuestion.new(
      description: 'Rate your level of stress',
      unit: level_of_stress_unit)
  end

  let(:psychological_pain_question) do
    psychological_pain_unit = Unit.new(
      min_value: 1,
      max_value: 5,
      min_value_description: 'Low',
      max_value_description: 'High')
    MeasurableQuestion.new(
      description: 'Rate your level of psychological pain',
      unit: psychological_pain_unit)
  end


  let(:questionnaire) do
    questionnaire = Questionnaire.new
    questionnaire.add_question(1, psychological_pain_question)
    questionnaire.add_question(2, level_of_stress_question)
    questionnaire.add_question(3, taking_life_question)
    questionnaire.add_question(4, keywords_question)
    questionnaire.add_question(5, name_day_question)
    questionnaire
  end

  it 'lists questionnaires' do
    repository.should_receive(:all)
    service.list_questionnaires
  end

  describe 'adding questionnaire' do
    it 'allows to add Questionnaire to Repository' do
      repository.add(questionnaire)
    end
  end

  describe 'answering' do
    describe 'allows to answer by hash' do
      let(:user_id) { 2345 }
      let(:questionnaire_id) { questionnaire.id }
      let(:answer_params) do
        {
          '1' => {
            'value' => 2
          },
          '2' => {
            'value' => 3
          },
          '3' => {
            'choice_id' => 5
          },
          '4' => {
            'choice_ids' => [2, 4]
          },
          '5' => {
            'text' => 'Good day'
          }
        }
      end

      before do
        repository.add(questionnaire)
        service.answer(user_id, questionnaire_id, answer_params)
      end

      let(:answer_group) { answer_group_repository.all.first }
      subject { answer_group }
      its(:'questionnaire.id') { should == questionnaire.id }
      its(:answers) { should have(5).items }
      its(:user_id) { should == user_id }
      describe 'measurable answer' do
        subject { answer_group.answers[0] }
        its(:'question.id') { should == psychological_pain_question.id }
        its(:value) { should == 2 }
        it { should be_a(MeasurableAnswer) }
      end
      describe 'measurable answer 2' do
        subject { answer_group.answers[1] }
        its(:'question.id') { should == level_of_stress_question.id }
        its(:value) { should == 3 }
        it { should be_a(MeasurableAnswer) }
      end
      describe 'single choice answer' do
        subject { answer_group.answers[2] }
        its(:'question.id') { should == taking_life_question.id }
        its(:choice_id) { should == 5 }
        its(:answer) { should == 'Very often' }
        it { should be_a(SingleChoiceAnswer) }
      end
      describe 'multiple choice answer' do
        subject { answer_group.answers[3] }
        its(:'question.id') { should == keywords_question.id }
        its(:choice_ids) { should == [2, 4] }
      end
      describe 'text answer' do
        subject { answer_group.answers[4] }
        its(:'question.id') { should == name_day_question.id }
        its(:text) { should == 'Good day' }
        it { should be_a(TextAnswer) }
      end
    end

    it 'allows to answer to a questionnaire' do
      answer_group = AnswerGroup.new

      level_of_stress_answer = MeasurableAnswer.new({
        value: 2, question: level_of_stress_question })

      psychological_pain_answer = MeasurableAnswer.new({
        value: 3, question: psychological_pain_question })

      answer_group.add_answer(level_of_stress_answer)
      answer_group.add_answer(psychological_pain_answer)

      answer_group.answers.should == [level_of_stress_answer, psychological_pain_answer]
    end
  end
end
