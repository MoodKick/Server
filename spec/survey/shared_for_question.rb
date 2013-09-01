include Survey

shared_examples 'a question' do
  let(:id) { 1234 }
  let(:description) { 'desc1' }

  it 'has description' do
    subject.description = description
    subject.description.should == description
  end

  it 'has id' do
    subject.id = id
    subject.id.should == id
  end

  describe 'accepts params hash in constructor' do
    subject do
      described_class.new({ description: description })
    end

    its(:description) { should == description }
  end
end
