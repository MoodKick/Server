require 'spec_helper'

describe HopeItemRepository do
  let(:repository) { HopeItemRepository.new }
  before do
    repository.delete_all
  end
  let(:client_id) { 1234 }
  let(:item1) { HopeItem.new(client_id: client_id, title: 'title1') }
  let(:item2) { HopeItem.new(client_id: client_id, title: 'title2') }
  let(:item3) { HopeItem.new(client_id: 2345, title: 'title2') }

  describe '#delete' do
    before do
      repository.add(item1)
      repository.add(item3)
    end

    it 'deletes item by client_id and id' do
      id = 4321
      repository.delete(client_id, item1.id)
      HopeItem.all.should have(1).item
      HopeItem.first.title.should == 'title2'
    end
  end

  describe '#build_new' do
    it 'returns new hope item, given client id and attributes' do
      hope_item = repository.build_new(client_id, title: 'title1')
      hope_item.client_id.should == client_id
      hope_item.title.should == 'title1'
    end
  end

  describe '#update' do
    context 'when there is an item already persisted' do
      before do
        repository.add(item1)
      end

      it 'updates item' do
        updated_item = repository.by_client_id_and_id(item1.client_id,
                                                      item1.id)
        updated_item.title = 'New title'
        updated_item.text = 'New text'
        repository.update(updated_item)
        HopeItem.all.should have(1).item
        item = repository.by_client_id_and_id(item1.client_id,
                                              item1.id)
        item.title.should == 'New title'
        item.text.should == 'New text'
      end
    end
  end

  describe '#add' do
    let(:hope_item) { item1 }

    it 'persists hope item' do
      repository.add(hope_item)
      persisted = HopeItem.last
      persisted.client_id.should == client_id
      persisted.title.should == 'title1'
    end
  end

  describe '#by_client_id_and_id' do
    before do
      repository.add(item1)
      repository.add(item3)
    end

    subject { repository.by_client_id_and_id(client_id, item1.id) }
    it { should == item1 }
  end

  describe '#for_client_id' do
    before do
      repository.add(item1)
      repository.add(item2)
      repository.add(item3)
    end

    it 'returns all hope items for given client_id' do
      res = repository.for_client_id(client_id)
      res.should have(2).items
      res[0].title.should == 'title1'
      res[1].title.should == 'title2'
    end
  end
end
