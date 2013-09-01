require 'spec_helper'

include Survey

describe Unit do
  let(:min_value) { 1 }
  let(:max_value) { 9 }
  let(:min_value_description) { 'Min' }
  let(:max_value_description) { 'Max' }

  let(:unit) do
    Unit.new(min_value: min_value,
             max_value: max_value,
             min_value_description: min_value_description,
             max_value_description: max_value_description)
  end
  let(:subject) { unit }

  describe 'has min value' do
    its(:min_value) { should == min_value }
  end

  describe 'has max value' do
    its(:max_value) { should == max_value }
  end

  describe 'has min value description' do
    its(:min_value_description) { should == min_value_description }
  end

  describe 'has max value description' do
    its(:max_value_description) { should == max_value_description }
  end
end
