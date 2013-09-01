require 'spec_helper'

include Survey
describe AnswerGroup do
  let(:id) { 1234 }

  describe 'adding questions' do
    let(:answer) { SingleChoiceAnswer.new }
    before do
      subject.add_answer(answer)
    end

    its(:answers) { should == [answer] }
  end

  it 'has questionnaire' do
    questionnaire = Questionnaire.new
    subject.questionnaire = questionnaire
    subject.questionnaire.should == questionnaire
  end

  it 'has id' do
    subject.id = id
    subject.id.should == id
  end

  it 'has user' do
    user = User.new
    subject.user = user
    subject.user.should == user
  end

  it 'gives answer by question' do
    question1 = TextQuestion.new
    question2 = TextQuestion.new

    answer1 = TextAnswer.new(question: question1)
    answer2 = TextAnswer.new(question: question2)
    subject.add_answer(answer1)
    subject.add_answer(answer2)

    subject.answer_for_question(question1).should == answer1
    subject.answer_for_question(question2).should == answer2
  end
end
