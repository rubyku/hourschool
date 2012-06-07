require 'spec_helper'

describe Series::EventSchedule do
  describe 'class methods' do

    after(:each) do
      Timecop.return
    end

    let(:cst) { TZInfo::Timezone.get('America/Chicago')     }
    let(:pst) { TZInfo::Timezone.get('America/Los_Angeles') }
    let(:stub_time) { Time.zone.local(2010, 6, 1, 17, 0, 0)       }

    let(:start_time)  { Time.now.in_time_zone }

    let(:end_time)    { 1.year.from_now.in_time_zone }

    let(:schedule_hash) { 
      {:start_date  => {:time => start_time.in_time_zone, :zone => "Central Time (US & Canada)"},
       :end_time    => end_time.in_time_zone,
       :rrules      => [{:validations => {:day=>[1]}, :rule_type=>"IceCube::WeeklyRule", :interval=>1}],
       :exrules     => [],
       :rtimes      => [],
       :extimes     => []}
      }
      
    let(:next_monday) { 1.week.from_now.monday.in_time_zone }

    it 'start_end_from_hash' do

      options    = {:start_time => start_time.to_s,
                    :end_time   => end_time.to_s}

      result_start, result_end = Series.start_end_from_hash(options)

      result_start.to_date.should == start_time.to_date
      result_end.to_date.should   == end_time.to_date
    end

    describe '#schedule_from_hash' do
      it '' do
        options    = {:start_time => start_time.to_s,
                      :end_time   => end_time.to_s,
                      :weekdays   => [:monday]}

        schedule = Series.schedule_from_hash(options)


        puts schedule.to_hash
        schedule.occurs_on?(next_monday).should be_true
      end
    end

    describe 'schedule' do
      it 'is nil when hash is empty' do
        Factory.stub(:series).send(:attribute, :schedule).should be_nil
      end
    end

    describe 'build_events!', :db => true do
      it 'creates some mother effing events' do
        series = Factory.stub(:series, :schedule_hash => schedule_hash)
        series.build_events!
        ScheduleEvent.where(:starts_at => next_monday, :published => false).first.should_not be_nil
      end
    end
  end
end