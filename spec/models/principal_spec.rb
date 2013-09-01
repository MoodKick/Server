require_relative '../../app/models/principal'
require_relative '../../app/models/claim'
require_relative '../../app/models/role'

describe Principal do
  describe 'has_claim?' do
    let(:user) { stub }

    context 'Claim::ClientAccess' do
      it 'is true if user has role Role::Client' do
        user.stub!(:has_role?).with(Role::Client) { true }
        subject.has_claim?(user, Claim::ClientAccess).should be_true
      end

      it 'is false if user has no role Role::Client' do
        user.stub!(:has_role?).with(Role::Client) { false }
        subject.has_claim?(user, Claim::ClientAccess).should be_false
      end
    end

    context 'Claim::AdminAccess' do
      it 'is true if user has role Role::Admin' do
        user.stub!(:has_role?).with(Role::Admin) { true }
        subject.has_claim?(user, Claim::AdminAccess).should be_true
      end

      it 'is false if user has no role Role::Admin' do
        user.stub!(:has_role?).with(Role::Admin) { false }
        subject.has_claim?(user, Claim::AdminAccess).should be_false
      end
    end

    context 'Claim::TherapistAccess' do
      it 'is true if user has role Role::Therapist' do
        user.stub!(:has_role?).with(Role::Therapist) { true }
        subject.has_claim?(user, Claim::TherapistAccess).should be_true
      end

      it 'is false if user has no role Role::Therapist' do
        user.stub!(:has_role?).with(Role::Therapist) { false }
        subject.has_claim?(user, Claim::TherapistAccess).should be_false
      end
    end

    context 'unknown claim' do
      it 'raises exception' do
        expect { subject.has_claim?(user, 'unknown') }.to raise_exception(Principal::UnknownClaim)
      end
    end

    context 'when user is nil' do
      it 'is false' do
        subject.has_claim?(nil, 'whatever').should be_false
      end
    end
  end
end
