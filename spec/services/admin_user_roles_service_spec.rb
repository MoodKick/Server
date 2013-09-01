require_relative '../../app/services/admin_user_roles_service'
require_relative '../../app/models/role'

describe AdminUserRolesService do
  let(:user_repository) { stub }
  let(:role_repository) { stub }
  let(:user) { stub }
  let(:user_id) { 1234 }
  let(:service) { AdminUserRolesService.new(user_repository, role_repository) }
  let(:subscriber) { stub }

  describe '#list' do
    context 'when success' do
      it 'provides user, all roles and existing roles of user' do
        existing_roles = [Role::Therapist, Role::Admin]
        user.stub!(:roles) { existing_roles }
        user_repository.stub!(:find_by_id).with(user_id) { user }
        all_roles = stub
        role_repository.stub!(:all) { all_roles }

        subscriber.should_receive(:success).with(
          user, all_roles, existing_roles)
        service.list(user_id, subscriber)
      end
    end
  end

  describe '#add' do
    let(:role_name) { 'Therapist' }
    before do
      user_repository.stub!(:find_by_id).with(user_id) { user }
      role_repository.stub!(:by_name).with('Therapist') { Role::Therapist }
    end

    it 'tells subscriber not_found if role cannot be found' do
      role_repository.stub!(:by_name) { nil }
      subscriber.should_receive(:not_found)
      service.add(user_id, role_name, subscriber)
    end

    it 'tells subscriber not_found if user cannot be found' do
      user_repository.stub!(:find_by_id).with(user_id) { nil }
      subscriber.should_receive(:not_found)
      service.add(user_id, role_name, subscriber)
    end

    context 'when user can be found and role can be found' do
      before do
        role_repository.stub!(:by_name).with(role_name) { Role::Therapist }
        user_repository.stub!(:update).with(user)
        user.stub!(:add_role).with(Role::Therapist)
        subscriber.stub!(:success)
      end

      it 'adds given role to the user' do
        user.should_receive(:add_role).with(Role::Therapist)
        service.add(user_id, role_name, subscriber)
      end

      it 'persists user' do
        user_repository.should_receive(:update).with(user)
        service.add(user_id, role_name, subscriber)
      end

      it 'notifies subscriber about success' do
        subscriber.should_receive(:success).with(user)
        service.add(user_id, role_name, subscriber)
      end
    end
  end

  describe '#remove' do
    let(:role_name) { 'Therapist' }
    let(:role) { Role::Therapist }

    context 'when user and role can be found' do
      before do
        role_repository.stub!(:by_name).with(role_name) { role }
        user_repository.stub!(:find_by_id).with(user_id) { user }
        user_repository.stub!(:update).with(user)
        user.stub!(:remove_role).with(role)
        subscriber.stub!(:success).with(user)
      end

      it 'removes role from user' do
        user.should_receive(:remove_role).with(role)
        service.remove(user_id, role_name, subscriber)
      end

      it 'persists user' do
        user_repository.should_receive(:update).with(user)
        service.remove(user_id, role_name, subscriber)
      end

      it 'notifies subscriber about success' do
        subscriber.should_receive(:success).with(user)
        service.remove(user_id, role_name, subscriber)
      end
    end

    it 'notifies subscriber about not found if user cannot be found' do
      user_repository.stub!(:find_by_id).with(user_id) { nil }
      role_repository.stub!(:by_name).with(role_name) { role }

      subscriber.should_receive(:not_found)
      service.remove(user_id, role_name, subscriber)
    end

    it 'notifies subscriber about not found if role cannot be found' do
      role_repository.stub!(:by_name).with(role_name) { nil }
      user_repository.stub!(:find_by_id).with(user_id) { user }

      subscriber.should_receive(:not_found)
      service.remove(user_id, role_name, subscriber)
    end
  end
end
