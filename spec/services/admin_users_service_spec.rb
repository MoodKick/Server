require_relative '../../app/services/admin_users_service'

describe AdminUsersService do
  let(:repository) { stub }
  let(:subscriber) { stub }
  let(:id) { 1234 }

  subject { AdminUsersService.new(repository) }

  describe '#list' do
    it 'succeeds with a list of all users' do
      users = stub
      repository.stub!(:all) { users }
      subscriber.should_receive(:success).with(users)
      subject.list(subscriber)
    end
  end

  describe '#show' do
    context 'when user can be found' do
      it 'returns a single user from repository by id' do
        user = stub
        repository.stub!(:find_by_id).with(id) { user }
        subscriber.should_receive(:success).with(user)

        subject.show(id, subscriber)
      end
    end

    context 'when user cannot be found' do
      it 'notifies about failure' do
        repository.stub!(:find_by_id).with(id) { nil }
        subscriber.should_receive(:not_found)

        subject.show(id, subscriber)
      end
    end
  end

  describe '#add' do
    it 'succeeds with new user' do
      user = stub
      repository.stub!(:build_new) { user }
      subscriber.should_receive(:success).with(user)
      subject.add(subscriber)
    end
  end

  describe '#create' do
    let(:user) { stub }
    let(:params) do
      {
        username: 'Username',
        full_name: 'Full name',
        location: 'Hovedstaden',
        email: 'whatever@mail.com',
        description: 'Some description'
      }
    end
    before do
      repository.stub!(:build_new) { user }
      [:username=, :full_name=, :location=, :email=,
       :description=, :password=, :password_confirmation=].each do |attr|
        user.stub!(attr)
      end
      repository.stub!(:add).with(user) { true }
      subscriber.stub!(:success).with(user)
    end

    it 'builds user from params' do
      user.should_receive(:username=).with(params[:username])
      user.should_receive(:full_name=).with(params[:full_name])
      user.should_receive(:location=).with(params[:location])
      user.should_receive(:email=).with(params[:email])
      user.should_receive(:description=).with(params[:description])
      user.should_receive(:password=).with(params[:password])
      user.should_receive(:password_confirmation=).
        with(params[:password_confirmation])
      subject.create(params, subscriber)
    end

    it 'persists built user' do
      repository.should_receive(:add).with(user)
      subject.create(params, subscriber)
    end

    it 'succeeds when user can be persisted' do
      subscriber.should_receive(:success).with(user)
      subject.create(params, subscriber)
    end

    it 'fails with validation_failure if user cannot be persisted' do
      repository.stub!(:add).with(user) { false }
      subscriber.should_receive(:validation_failure).with(user)
      subject.create(params, subscriber)
    end
  end

  describe '#update' do
    context 'when user can be found' do
      let(:user) { stub }
      let(:params) { stub }
      let(:subscriber) { stub.tap { |s| s.stub!(:success) } }

      before do
        repository.stub!(:find_by_id).with(id) { user }
      end

      it 'updates user and saves it' do
        user.should_receive(:update_attributes).with(params) { true }
        subject.update(id, params, subscriber)
      end

      context 'when user can be updated' do
        it 'notifies subscriber about success' do
          user.stub!(:update_attributes) { true }
          subscriber.should_receive(:success).with(user)

          subject.update(id, params, subscriber)
        end
      end

      context 'when user cannot be updated' do
        it 'notifies subscriber about failure' do
          user.stub!(:update_attributes) { false }
          subscriber.should_receive(:validation_failure).with(user)

          subject.update(id, params, subscriber)
        end
      end
    end
  end

  describe '#delete' do
    it 'tells repository to remove user' do
      repository.should_receive(:remove).with(id)
      subscriber.stub!(:success)

      subject.delete(id, subscriber)
    end

    it 'notifies subscriber about success' do
      repository.stub!(:remove)

      subscriber.should_receive(:success)
      subject.delete(id, subscriber)
    end
  end
end
