require_relative '../../app/services/client_chest_of_hope_service'

describe ClientChestOfHopeService do
  subject do
    ClientChestOfHopeService.new(repository)
  end

  let(:client) { stub(id: 1234) }
  let(:item_id) { 4321 }
  let(:repository) { stub }

  describe '#find' do
    let(:subscriber) { stub }

    it 'returns Hope item from repository' do
      item = stub
      repository.stub!(:by_client_id_and_id).with(client.id, item_id) {
        item
      }
      subscriber.should_receive(:success).with(item)
      subject.find(client, item_id, subscriber)
    end
  end

  describe '#delete' do
    let(:subscriber) { stub }

    before do
      repository.stub!(:delete)
      subscriber.stub!(:success)
    end

    it 'removes chest item from repository by cliend_id and id' do
      repository.should_receive(:delete).with(client.id, item_id)
      subject.delete(client, item_id, subscriber)
    end

    it 'notifies subscriber about success' do
      subscriber.should_receive(:success)
      subject.delete(client, item_id, subscriber)
    end
  end

  describe '#add_hope_item' do
    let(:item) { stub }

    it 'adds hope item to the repository' do
      repository.stub!(:build_new).with(client.id, title: 'title1') {
        item
      }
      repository.should_receive(:add).with(item)
      subject.add_hope_item(client, 'title1')
    end
  end

  describe '#list' do
    let(:items) { [stub, stub] }
    it 'notifies about success to subscriber with list of hope items
        for client' do
      repository.stub(:for_client_id) { items }
      subscriber = stub
      subscriber.should_receive(:success).with(items)
      subject.list(client, subscriber)
    end
  end

  describe '#build_new_text' do
    let(:item) { stub }
    it 'returns new hope item for given client with type text' do
      repository.stub!(:build_new).with(client.id, type: 'text') { item }
      subject.build_new_text(client).should == item
    end
  end

  describe '#update_text' do
    let(:item) { stub }
    let(:subscriber) { stub }
    let(:new_title) { 'New title' }
    let(:new_text) { 'New text' }

    before do
      repository.stub!(:by_client_id_and_id).
        with(client.id, item_id) { item }
    end

    context 'when item is valid' do
      let(:action) { -> do
        subject.update_text(client, item_id, new_title,
                            new_text, subscriber)
      end }

      before do
        subscriber.stub!(:success)
        item.stub!(:title=)
        item.stub!(:text=)
        repository.stub!(:update)
      end

      #FIXME: this is terrible
      it 'tells repository to persist item with new attributes' do
        item.should_receive(:title=).with(new_title).ordered
        item.should_receive(:text=).with(new_text).ordered
        repository.should_receive(:update).with(item).ordered
        action.call
      end

      it 'notifies subscriber about success' do
        subscriber.should_receive(:success).with(item)
        action.call
      end
    end

    context 'when item is not valid' do
      it 'notifies subscriber about failure' do
        subscriber.should_receive(:not_valid).with(item, [:title_blank])
        subject.update_text(client, item_id, '', new_text, subscriber)
      end
    end
  end

  describe '#add_text' do
    let(:item) { stub }
    let(:subscriber) { stub }

    context 'when item is valid' do
      before do
        repository.stub!(:build_new).with(client.id, {
          title: 'title1', text: 'text1', type: 'text' }) { item }
        repository.stub!(:add)
        subscriber.stub!(:success)
      end
      let(:action) { -> do
        subject.add_text(client, 'title1', 'text1', subscriber)
      end }

      it 'builds hope item and adds it to repository' do
        repository.should_receive(:add).with(item)
        action.call
      end

      it 'notifies subscriber about success' do
        subscriber.should_receive(:success)
        action.call
      end
    end

    context 'when item is not valid' do
      it 'notifies about failed validation if item is not valid' do
        repository.stub!(:build_new) { item }
        subscriber.should_receive(:not_valid).with(item, [:title_blank])
        subject.add_text(client, '', 'text1', subscriber)
      end
    end
  end
end
