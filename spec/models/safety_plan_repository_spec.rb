require 'spec_helper'

describe SafetyPlanRepository do
  before do
    subject.delete_all
  end

  describe '#last_version_for_client_id' do
    let(:safety_plan) do
      SafetyPlan.new do |p|
        p.client_id = 1
        p.body = 'body1'
        p.created_at = 1.hour.ago
      end
    end

    let(:old_safety_plan) do
      SafetyPlan.new do |p|
        p.client_id = 1
        p.body = 'body2'
        p.created_at = 1.day.ago
      end
    end

    let(:safety_plan_of_other_client) do
      SafetyPlan.new do |p|
        p.client_id = 2
        p.body = 'body3'
      end
    end

    before do
      subject.delete_all

      subject.add(safety_plan)
      subject.add(old_safety_plan)
      subject.add(safety_plan_of_other_client)
    end

    it 'returns safety plan by client id with the last created_at' do
      subject.last_version_for_client_id(1).should == safety_plan
    end

  end

  describe '#add' do
    let(:safety_plan) { stub }

    it 'persists safety plan' do
      safety_plan.should_receive(:save)
      subject.add(safety_plan)
    end
  end

  describe '#build_new' do
    it 'returns new safety plan, given client_id' do
      subject.build_new(1).attributes.should == SafetyPlan.new(client_id: 1).attributes
    end
  end
end
