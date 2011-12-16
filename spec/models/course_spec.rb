require 'spec_helper'

describe Course do
  describe 'time' do
    let(:cst) { TZInfo::Timezone.get('America/Chicago')     }
    let(:pst) { TZInfo::Timezone.get('America/Los_Angeles') }
    let(:now) { Time.zone.local(2010, 6, 1, 17, 0, 0)       }

    it 'active? will be false if class has passed in another time zone' do
      Timecop.freeze(now) do
        Time.zone = cst
        course   = Factory.stub(:course, :date => Time.zone.now)
        Time.zone = pst
        Timecop.travel(1.hour)
        course.should_not be_active
      end
    end


    it 'active? will be true when the class is viewed from the same time zone' do
      Timecop.freeze(now) do
        Time.zone = cst
        course    = Factory.stub(:course, :date => Time.zone.now)
        Timecop.travel(-1.hour)
        course.should be_active
      end
    end

  end
end