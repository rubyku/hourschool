module Concerns::Models::Generic
  
  def foo
    puts "foo"
  end
  
  extend ActiveSupport::Concern
  
  module ClassMethods
    def group_by_month
      group("extract( month from DATE(created_at))")
    end
  end
end