require 'spec_helper'

include Survey
describe MeasurableQuestion do

  let(:description) { 'Desc1' }
  let(:id) { 2 }
  let(:unit) { stub }
  subject { MeasurableQuestion.new }

  it 'has description' do
    subject.description = description
    subject.description.should == description
  end

  it 'has id' do
    subject.id = id
    subject.id.should == id
  end
end
