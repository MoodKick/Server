require 'spec_helper'

include Survey

shared_examples_for 'an answer' do
  let(:id) { 1234 }
  describe 'accepts params hash in constructor' do
    subject do
      described_class.new({ question: question })
    end

    its(:question) { should == question }
  end

  it 'has question' do
    subject.question = question
    subject.question.should == question
  end

  it 'has id' do
    subject.id = id
    subject.id.should == id
  end
end

describe MeasurableAnswer do
  it_behaves_like 'an answer' do
    let(:question) { MeasurableQuestion.new }
  end
  let(:value) { 3 }

  it 'has value' do
    subject.value = value
    subject.value.should == value
  end
end

describe SingleChoiceAnswer do
  it_behaves_like 'an answer' do
    let(:question) { SingleChoiceQuestion.new }
  end

  it 'has choice_id' do
    subject.choice_id = 4321
    subject.choice_id.should == 4321
  end

  context 'when it has a question and value' do
    let(:choice_id) { 3 }
    let(:question) do
      res = SingleChoiceQuestion.new
      res.stub!(:choice_by_id).with(3) { choice }
      res
    end

    let(:choice) do
      res = stub
      res.stub!(:value) { 'I am third' }
      res
    end

    subject do
      SingleChoiceAnswer.new({
        choice_id: choice_id,
        question: question })
    end

    it 'has answer which is a value of choice' do
      subject.answer.should == 'I am third'
    end
  end
end

describe MultipleChoiceAnswer do
  it_behaves_like 'an answer' do
    let(:question) { MultipleChoiceQuestion.new }
  end

  it 'has choice_ids' do
    subject.choice_ids = [23, 43]
    subject.choice_ids.should == [23, 43]
  end
end

