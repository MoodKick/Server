include Survey

shared_examples 'a question with choices' do
  context 'when there are choices' do
    let(:choices) { [stub(id: 1), stub(id: 5)] }

    subject do
      described_class.new({ choices: choices })
    end

    it 'gives choice by id' do
      subject.choice_by_id(1).should == choices[0]
      subject.choice_by_id(5).should == choices[1]
    end
  end
end
