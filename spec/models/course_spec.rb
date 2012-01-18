require 'spec_helper'

describe Course do
  describe 'time' do
    let(:cst) { TZInfo::Timezone.get('America/Chicago')     }
    let(:pst) { TZInfo::Timezone.get('America/Los_Angeles') }
    let(:now) { Time.zone.local(2010, 6, 1, 17, 0, 0)       }

    it 'active? will be true when the class is viewed from the same time zone' do
      Timecop.freeze(now) do
        Time.zone = cst
        course    = Factory.stub(:course, :date => Date.today)
        Timecop.travel(1.hour)
        course.should be_active
      end
    end

  end
end