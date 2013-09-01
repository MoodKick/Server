require_relative '../spec_helper'

describe 'User' do
  describe 'has daily journals' do

    def daily_journal_entries_should_be_the_same(specifications, daily_journal_entries)
      specifications.map(&:name).should == daily_journal_entries.map(&:name)
    end

    let(:daily_journal_entry) { FactoryGirl.build(:daily_journal, created_at: 1.years.ago) }
    let(:daily_journal_entry_old) { FactoryGirl.build(:daily_journal, created_at: 2.year.ago) }
    let(:daily_journal_entries) { [daily_journal_entry, daily_journal_entry_old] }
    let(:user) { FactoryGirl.build(:user) }

    it 'may be added' do
      user.add_daily_journal_entry(daily_journal_entry)
      user.add_daily_journal_entry(daily_journal_entry_old)
      user.save

      daily_journal_entries_should_be_the_same(
        daily_journal_entries,
        user.daily_journal_entries)

      daily_journal_entries_should_be_the_same(
        daily_journal_entries,
        User.find(user.id).daily_journal_entries)
    end

    it 'may be found by id' do
      user.add_daily_journal_entry(daily_journal_entry)
      user.add_daily_journal_entry(daily_journal_entry_old)
      user.save

      user.daily_journal_entry_by_id(daily_journal_entry.id).should == daily_journal_entry
      user.daily_journal_entry_by_id(daily_journal_entry_old.id).should == daily_journal_entry_old
    end

    it 'may be sorted by created_at' do
      user.add_daily_journal_entry(daily_journal_entry)
      user.add_daily_journal_entry(daily_journal_entry_old)
      user.save

      entries = user.daily_journal_entries_sorted_by_created_at
      entries[0].should == daily_journal_entry_old
      entries[1].should == daily_journal_entry
    end

    it 'may be found for last n days' do
      e1 = FactoryGirl.build(:daily_journal, created_at: 10.days.ago)
      e2 = FactoryGirl.build(:daily_journal, created_at: 9.days.ago + 1.minute)
      e3 = FactoryGirl.build(:daily_journal, created_at: 0.days.ago)
      [e1, e2, e3].each do |entry|
        user.add_daily_journal_entry(entry)
      end
      user.save

      user.daily_journal_entries_for_last_n_days(9).should == [e2, e3]
    end
  end

  describe 'roles' do
    describe 'Therapist' do
      describe 'may have clients' do
        let(:client) { FactoryGirl.create(:client) }
        let(:client2) { FactoryGirl.create(:client) }
        let(:therapist) { FactoryGirl.create(:therapist) }

        it 'may be added' do
          therapist.add_client(client)
          therapist.add_client(client2)
          therapist.clients.map(&:id).should == [client.id, client2.id]
          client.primary_therapist.should == therapist
          client2.primary_therapist.should == therapist
        end

        it 'may be found by id' do
          therapist.add_client(client)
          therapist.add_client(client2)
          therapist.save

          therapist.client_by_id(client.id).should == client
          therapist.client_by_id(client2.id).should == client2
        end
      end
    end
  end

  describe 'has_role?' do
    let(:user) { User.new }

    it 'is false if user has no role' do
      user.has_role?(Role::Therapist).should be_false
      user.has_role?(Role::Client).should be_false
      user.has_role?(Role::Relative).should be_false
      user.has_role?(Role::Admin).should be_false
    end

    it 'is true if user has given role' do
      user.add_role(Role::Therapist)
      user.has_role?(Role::Therapist).should be_true
      user.has_role?(Role::Client).should be_false
    end
  end

  describe 'roles' do
    let(:user) { User.new }

    it 'is an empty array when user has no roles' do
      user.roles.should == []
    end

    it 'is an array of Role objects' do
      user.add_role(Role::Therapist)
      user.add_role(Role::Admin)
      user.roles.should include(Role::Therapist, Role::Admin)
    end
  end

  describe 'remove_role' do
    let(:user) { User.new }

    it 'removes role' do
      user.add_role(Role::Therapist)
      user.add_role(Role::Admin)

      user.remove_role(Role::Therapist)
      user.roles.should == [Role::Admin]
    end

    it 'does nothing if user has no such role' do
      user.remove_role(Role::Therapist)
      user.roles.should == []
    end
  end
end
