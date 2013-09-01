require_relative '../../app/services/brochure_service'

describe BrochureService do
  let(:repository) { stub }
  subject { BrochureService.new(repository) }

  describe '#get_help' do
    it 'returns Help brochure from repository' do
      help_brochure = stub
      repository.stub!(:by_type).with(:help) { help_brochure }

      subject.get_help.should == help_brochure
    end
  end

  describe '#update_help' do
    it 'tells repository to update :help brochure' do
      brochure_body = stub
      repository.should_receive(:update_by_type).with(:help, brochure_body)
      subject.update_help(brochure_body)
    end
  end

  describe '#get_suicidal_thoughts' do
    it 'returns SuicidalThoughts brochure from repository' do
      suicidal_thoughts_brochure = stub
      repository.stub!(:by_type).with(:suicidal_thoughts) { suicidal_thoughts_brochure }

      subject.get_suicidal_thoughts.should == suicidal_thoughts_brochure
    end
  end

  describe '#update_suicidal_thoughts' do
    it 'tells repository to update :suicidal_thoughts brochure' do
      brochure_body = stub
      repository.should_receive(:update_by_type).with(:suicidal_thoughts, brochure_body)
      subject.update_suicidal_thoughts(brochure_body)
    end
  end

  describe '#get_advice_for_relatives' do
    it 'returns AdviceForRelatives brochure from repository' do
      advice_for_relatives_brochure = stub
      repository.stub!(:by_type).with(:advice_for_relatives) { advice_for_relatives_brochure }

      subject.get_advice_for_relatives.should == advice_for_relatives_brochure
    end
  end

  describe '#update_advice_for_relatives' do
    it 'tells repository to update :advice_for_relatives brochure' do
      brochure_body = stub
      repository.should_receive(:update_by_type).with(:advice_for_relatives, brochure_body)
      subject.update_advice_for_relatives(brochure_body)
    end
  end
end
