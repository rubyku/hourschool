require 'spec_helper'

describe Course do
  describe 'time' do
    let(:cst) { TZInfo::Timezone.get('America/Chicago')     }
    let(:pst) { TZInfo::Timezone.get('America/Los_Angeles') }
    let(:now) { DateTime.parse("2011-10-30 9pm").to_time    } # 9pm central

    it 'active? will be false if class has passed in another time zone' do
      Timecop.freeze(now) do
        Time.zone = cst
        course   = Factory.stub(:course, :date => Time.current) # 9 pm central
        Time.zone = pst                                         # 9pm  PST (11 pm CST)
        Timecop.travel(1.hour)                                  # 10pm PST (12 PM CST)
        course.should_not be_active
      end
    end


    it 'active? will be true when the class is viewed from the same time zone' do
      Timecop.freeze(now) do
        puts Time.current
        puts Time.zone
        Time.zone = pst
        puts Time.current
        course   = Factory.stub(:course, :date => Time.current) # 9 pm PST
        Time.zone = cst                                         # 9pm  CST (7 pm PST)
        Timecop.travel(1.hour)                                  # 10pm CST (8 pm PST)
        puts Time.zone
        puts "========================="
        puts Time.current
        puts course.starts_at
        puts course.starts_at > Time.current
        course.should be_active
      end
    end

  end
end