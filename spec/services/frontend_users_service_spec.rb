require_relative '../../app/services/frontend_users_service'

describe FrontendUsersService do
  let(:repository) { stub }
  let(:id) { 1234 }

  subject { FrontendUsersService.new(repository) }

  describe '#list' do
    it 'returns a list of all public users excluding given' do
      users = stub
      excluding = stub
      repository.stub!(:public_excluding_id).with(excluding) { users }
      subject.list_excluding(excluding).should == users
    end
  end

  describe '#show' do
    it 'returns a public user by id' do
      user = stub
      repository.stub!(:public_by_id).with(id) { user }
      subject.show(id).should == user
    end
  end
end
