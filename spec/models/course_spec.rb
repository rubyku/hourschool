require 'spec_helper'

describe Course do
  describe 'time' do
    after(:each) do
      Timecop.return
    end

    let(:cst) { TZInfo::Timezone.get('America/Chicago')     }
    let(:pst) { TZInfo::Timezone.get('America/Los_Angeles') }
    let(:stub_time) { Time.zone.local(2010, 6, 1, 17, 0, 0) } # Tue, 01 Jun 2010 17:00:00 CDT -05:00

    it 'active? will be true when the course is viewed from the same time zone' do
      pending
      Timecop.freeze(stub_time) do
        Time.zone = cst
        course    = FactoryGirl.stub(:course, :date => Date.today)
        Timecop.travel(1.hour)
        course.should be_active
      end
    end


    it "works like i would expect it to" do
      Timecop.freeze(stub_time.beginning_of_day) do
        puts Time.zone
        puts Time.now
        puts Time.zone.now
        puts Time.now.in_time_zone
        puts "=============="
        0.upto(47) do |i|
          time = (Time.now + i.hours)
          c = FactoryGirl.create(:course, :starts_at => time)
          puts "Course starts_at: #{c.starts_at} | utc: #{c.starts_at.utc}"
        end


        puts "================="

        puts Time.now.in_time_zone.inspect
        Timecop.travel(1.hour)
        puts Time.now.in_time_zone.inspect
        puts "~~~~~~~~~~~~~~~~~"
        puts Date.today.inspect
        puts Time.zone.now.to_date

        courses = Course.where("DATE(starts_at) = DATE(?)", Time.zone.now.to_date)
        courses.count.should == 24

        courses = Course.where("DATE(starts_at) = '#{Time.zone.now.to_date + 1.days}'")
        courses.count.should == 24
      end
    end

  end
end



