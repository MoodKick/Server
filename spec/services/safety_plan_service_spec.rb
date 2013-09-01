require 'ostruct'
require_relative '../../app/services/safety_plan_service'

describe SafetyPlanService do
  describe '#create' do
    subject { SafetyPlanService.new(repository) }
    let(:client_id) { 'some id' }
    let(:subscriber) { stub }

    describe 'persists safety plan to repository' do
      let(:body) { 'some text' }
      let(:therapist_id) { 'therapist id' }
      let(:therapist) { stub(id: therapist_id) }
      let(:safety_plan) { OpenStruct.new }
      let(:repository) do
        res = stub
        res.stub!(:build_new).with(client_id) do
          safety_plan.client_id = client_id
          safety_plan
        end
        res
      end
      let(:safety_plan_attributes) do
        { body: body }
      end

      it 'with attributes and created_by as thereapist' do
        repository.should_receive(:add) do |safety_plan, ret|
          safety_plan.body.should == body
          safety_plan.client_id.should == client_id
          safety_plan.created_by.should == therapist_id
        end
        subject.create(safety_plan_attributes, client_id, therapist)
      end

      it 'returns created safety plan' do
        repository.stub!(:add)
        subject.create(safety_plan_attributes, client_id, therapist).should ==
          safety_plan
      end
    end

    describe '#show_for_client_id' do
      let(:repository) { stub }
      context 'when there is a safety plan' do
        let(:safety_plan) { stub }

        it 'succeeds with safety plan for specific client' do
          repository.stub!(:last_version_for_client_id).with(client_id) { safety_plan }
          subscriber.should_receive(:success).with(safety_plan)

          subject.show_for_client_id(client_id, subscriber)
        end
      end

      context 'when there is no safety plan' do
        let(:new_safety_plan) { stub }
        before do
          repository.stub!(:last_version_for_client_id) { nil }
          repository.stub!(:build_new).with(client_id) { new_safety_plan }
        end

        it 'succeeds with new safety plan' do
          subscriber.should_receive(:success).with(new_safety_plan)
          subject.show_for_client_id(client_id, subscriber)
        end
      end

    end
  end
end
