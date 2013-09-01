require_relative '../../app/services/content_object_service'

describe ContentObjectService do

  let(:repository) { stub }
  let(:path) { stub }
  let(:scanner) { stub }
  let(:id) { 2 }
  subject { ContentObjectService.new(repository, scanner, path) }
  let(:subscriber) { stub }

  describe '#update_all' do
    let(:content_object_attributes) { stub }
    before do
      scanner.stub!(:scan).with(path) { content_object_attributes }
      subscriber.stub!(:success)
      repository.stub!(:update_all_with).with(content_object_attributes)
    end

    it 'persists to the repository results of scanner' do
      repository.should_receive(:update_all_with).with(content_object_attributes)
      subject.update_all(subscriber)
    end

    it 'succeeds' do
      subscriber.should_receive(:success)
      subject.update_all(subscriber)
    end
  end

  describe '#list' do
    it 'succeeds with a list of all content objects' do
      cobs = stub
      repository.stub!(:all) { cobs }
      subscriber.should_receive(:success).with(cobs)
      subject.list(subscriber)
    end
  end

  describe '#show' do
    it 'succeeds with a content object found from repository by id' do
      cob = stub
      repository.stub!(:find).with(id) { cob }
      subscriber.should_receive(:success).with(cob)
      subject.show(id, subscriber)
    end
  end

  describe '#launched' do
    before do
      repository.stub!(:increase_launch_number)
      subscriber.stub!(:success)
    end

    it 'tells repository about it' do
      repository.should_receive(:increase_launch_number).with(id)
      subject.launched(id, subscriber)
    end

    it 'succeeds' do
      subject.launched(id, subscriber)
    end
  end
end
