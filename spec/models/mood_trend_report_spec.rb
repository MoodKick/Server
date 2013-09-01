require 'date'
require 'active_support/all'
require_relative '../../app/models/mood_trend_report'

module MoodKick
  module Test
    class FakeDateClock
      def self.frozen
        FakeDateClock.new(Date.new(2001, 2, 3))
      end

      def initialize(date)
        @date = date
      end

      def today
        @date
      end

      def -(n_days)
        @date - n_days
      end
    end
  end
end

describe MoodTrendReport do
  let(:client) { stub }
  let(:today) { Date.new(2001, 2, 3) }
  let(:n_days) { 30 }

  let(:subject) do
    report = MoodTrendReport.new(client, n_days)
    report.date_clock = MoodKick::Test::FakeDateClock.new(today)
    report
  end

  it 'knows the start date of report' do
    subject.start_date.should == today - n_days
  end

  it 'knows the end date of report' do
    subject.end_date.should == today
  end

  it 'knows number of days in period' do
    subject.number_of_days.should == n_days
  end

  it 'knows for which client it is' do
    subject.client.should == client
  end

  before do
    client.stub!(:daily_journal_entries_for_last_n_days).with(30) do
      @entries
    end
  end

  context "when there are daily journal entries for period" do
    context "knows number of days marked with" do
      before do
        @entries = [
          stub(angry: true, anxious: true, manic: true, calm: true),
          stub(angry: false, anxious: true, manic: true, calm: true),
          stub(angry: false, anxious: false,  manic: true, calm: true),
          stub(angry: false, anxious: false, manic: false, calm: true)
        ]
      end

      it 'anger' do
        subject.marked_with_anger.should == 1
      end

      it 'anxiety' do
        subject.marked_with_anxiety.should == 2
      end

      it 'mania' do
        subject.marked_with_mania.should == 3
      end

      it 'calmness' do
        subject.marked_with_calmness.should == 4
      end
    end

    context 'knows the best day' do
      let(:d1) { 1.day.ago }
      let(:d2) { 2.days.ago }

      it 'is the day with the highest happiness level' do
        @entries = [
          stub(calm: true, happiness_level: 4, created_at: d1),
          stub(calm: true, happiness_level: 5, created_at: d2)
        ]
        subject.best_day.should == d2
      end

      it 'is the day that is calm for the highest happiness level' do
        @entries = [
          stub(calm: true, happiness_level: 2, created_at: d1),
          stub(calm: false, happiness_level: 2, created_at: d2)
        ]
        subject.best_day.should == d1
      end
    end

    context 'knows the worst day' do
      let(:d1) { 1.day.ago }
      let(:d2) { 2.days.ago }
      let(:d3) { 3.days.ago }
      let(:d4) { 4.days.ago }

      it 'is the day with the lowest happiness level' do
        @entries = [
          stub(happiness_level: 1, anxious: true, angry: true, manic: true, created_at: d1),
          stub(happiness_level: 2, anxious: true, angry: true, manic: true, created_at: d2)
        ]
        subject.worst_day.should == d1
      end

      it 'is the day that is anxious, and angry and manic' do
        @entries = [
          stub(happiness_level: 1, anxious: true, angry: false, manic: false, created_at: d1),
          stub(happiness_level: 1, anxious: true, angry: true, manic: false, created_at: d2),
          stub(happiness_level: 1, anxious: true, angry: true, manic: true, created_at: d3)
        ]
        subject.worst_day.should == d3
      end
    end

    it 'knows happiness levels' do
      @entries = [
        stub(happiness_level: 1),
        stub(happiness_level: 1),
        stub(happiness_level: 2),
        stub(happiness_level: 5)
      ]
      subject.happiness_levels.should == [1, 1, 2, 5]
    end
  end

  context "when there are no daily journal entries for period" do
    before do
      @entries = []
    end

    context '#happiness_levels' do
      it 'is empty' do
        subject.happiness_levels.should == []
      end
    end

    context '#best_day' do
      it 'is nil' do
        subject.best_day.should be_nil
      end
    end

    context '#worst_day' do
      it 'is nil' do
        subject.worst_day.should be_nil
      end
    end

    context '#marked_with_mania' do
      it 'is 0' do
        subject.marked_with_mania.should == 0
      end
    end

    context '#marked_with_anxiety' do
      it 'is 0' do
        subject.marked_with_anxiety.should == 0
      end
    end

    context '#marked_with_calmness' do
      it 'is 0' do
        subject.marked_with_calmness.should == 0
      end
    end

    context '#marked_with_anger' do
      it 'is 0' do
        subject.marked_with_anger.should == 0
      end
    end
  end
end
