require 'spec_helper'

include Survey

describe Choice do
  let(:id) { 23 }
  let(:value) { 'whatever' }

  it 'has id' do
    subject.id = id
    subject.id.should == id
  end

  describe 'accepts params hash in constructor' do
    subject do
      Choice.new({ value: value })
    end

    its(:value) { should == value }
  end
end
