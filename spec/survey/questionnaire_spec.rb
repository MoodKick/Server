require 'spec_helper'

include Survey

describe Questionnaire do
  let(:id) { 1234 }
  let(:title) { 'Sample title' }

  describe 'adding questions' do
    let(:question1) { MeasurableQuestion.new }
    let(:question2) { SingleChoiceQuestion.new }

    let(:questionnaire) { Questionnaire.new }
    subject { questionnaire }

    before do
      questionnaire.add_question(1, question1)
      questionnaire.add_question(2, question2)
    end

    its(:questions) { should == [question1, question2] }
    it 'inserts them as ordered list' do
      questionnaire.question_by_n(1).should == question1
      questionnaire.question_by_n(2).should == question2
    end
  end

  describe 'accepts params has in constructor' do
    subject do
      Questionnaire.new(title: title)
    end

    its(:title) { should == title }
  end

  it 'has id' do
    subject.id = id
    subject.id.should == id
  end

  it 'has title' do
    subject.title = title
    subject.title.should == title
  end
end
