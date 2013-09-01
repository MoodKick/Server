require 'spec_helper'

describe PartyRepository do
  let(:repository) { PartyRepository.new }
  before do
    repository.delete_all
  end

  let(:client) { FactoryGirl.build(:client) }
  let(:therapist) { FactoryGirl.build(:therapist) }
  let(:relative) { FactoryGirl.build(:relative) }
  let(:admin) { FactoryGirl.build(:admin) }
  let(:user) { FactoryGirl.build(:user) }

  before do
    client.save
    therapist.save
    relative.save
    admin.save
    user.save
  end

  describe '#add' do
    it 'persists given user' do
      user = FactoryGirl.build(:client)
      repository.add(user)
      repository.all.should include(user)
    end
  end

  describe '#build_new' do
    it 'returns new user' do
      repository.build_new.should be_kind_of(User)
    end
  end

  describe '#update' do
    it 'saves given user' do
      client.full_name = 'New name'
      repository.update(client)
      User.find(client.id).should == client
    end
  end

  describe '#relatives' do
    it 'returns all relatives and only relatives' do
      res = repository.relatives
      res[0].should == relative
      res.should have(1).item
    end
  end

  describe '#clients' do
    it 'returns all clients and only clients' do
      res = repository.clients
      res[0].should == client
      res.should have(1).item
    end
  end

  describe '#therapists' do
    it 'returns all therapists and only therapists' do
      res = repository.therapists
      res[0].should == therapist
      res.should have(1).item
    end
  end

  describe '#all' do
    it 'returns all types of users' do
      res = repository.all
      res.should include(client)
      res.should include(therapist)
      res.should include(relative)
      res.should include(admin)
      res.should include(user)
      res.should have(5).items
    end
  end

  describe '#find' do
    it 'find user by id' do
      repository.find(client.id).should == client
    end
  end

  describe '#find_therapist' do
    it 'finds therapist by id' do
      repository.find_therapist(therapist.id).should == therapist
    end

    it 'finds only therapists' do
      repository.find_therapist(client.id).should be_nil
    end
  end

  describe '#find_client' do
    it 'finds client by id' do
      repository.find_client(client.id).should == client
    end

    it 'finds only clients' do
      repository.find_client(therapist.id).should be_nil
    end
  end

  describe '#find_relative' do
    it 'finds relative by id' do
      repository.find_relative(relative.id).should == relative
    end

    it 'finds only relatives' do
      repository.find_relative(therapist.id).should be_nil
    end
  end

  describe '#remove' do
    it 'removes user by id' do
      repository.remove(client.id)
      repository.all.should_not include(client)
    end
  end

  describe '#remove_client' do
    it 'removes client by id' do
      repository.remove_client(client.id)
      repository.clients.should_not include(client)
    end

    it 'removes only client' do
      repository.remove_client(therapist.id)
      repository.therapists.should include(therapist)
    end
  end

  describe '#remove_therapist' do
    it 'removes therapist by id' do
      repository.remove_therapist(therapist.id)
      repository.therapists.should_not include(therapist)
    end

    it 'removes only therapist' do
      repository.remove_therapist(client.id)
      repository.clients.should include(client)
    end
  end

  describe '#remove_relative' do
    it 'removes relative by id' do
      repository.remove_relative(relative.id)
      repository.relatives.should_not include(relative)
    end

    it 'removes only relative' do
      repository.remove_relative(therapist.id)
      repository.therapists.should include(therapist)
    end
  end

  describe '#find_by_username' do
    before do
      FactoryGirl.create(:user, username: 'other_username')
    end

    it 'returns user by username if it exists' do
      user = FactoryGirl.create(:user, username: 'username1')
      repository.find_by_username('username1').should == user
    end

    it 'returns nil if user with given username doesnt exist' do
      repository.find_by_username('username1').should be_nil
    end
  end

  describe '#find_by_id' do
    before do
      FactoryGirl.create(:user)
    end

    it 'returns user by id if it exists' do
      user = FactoryGirl.create(:user)
      repository.find_by_id(user.id).should == user
    end

    it 'returns nil if user with given id doesnt exist' do
      repository.find_by_id(1234).should be_nil
    end
  end

  describe 'public' do
    describe '#public_excluding' do
      it 'returns all users except admins and except user with given id' do
        client2 = FactoryGirl.create(:client)
        users = repository.public_excluding_id(client2.id)
        users.should include(client, therapist, relative)
        users.should_not include(admin, client2)
      end
    end

    describe '#public_by_id' do
      it 'returns user by id' do
        repository.public_by_id(client.id).should == client
      end

      it 'returns nil if user with this id is admin' do
        repository.public_by_id(admin.id).should be_nil
      end
    end
  end
end
