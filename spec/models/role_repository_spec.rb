require_relative '../../app/models/role'
require_relative '../../app/models/role_repository'

describe RoleRepository do
  describe '#all' do
    it 'returns all existing roles' do
      subject.all.should include(Role::Therapist, Role::Client, Role::Relative, Role::Admin)
    end
  end

  describe '#by_name' do
    it 'returns role by it\'s name' do
      subject.by_name('Therapist').should == Role::Therapist
    end

    it 'returns nil if it cannot be found' do
      subject.by_name('Made up').should be_nil
    end
  end
end
