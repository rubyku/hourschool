module UserSettings::Flags
  extend ActiveSupport::Concern

  included do
    cattr_accessor :flag_column_reader, :flag_column_writer
    cattr_accessor :flags
    self.flags = {}
  end

  module ClassMethods

    def set_flag_column(column_name)
      self.flag_column_reader = :"#{column_name}"
      self.flag_column_writer = :"#{column_name}="
    end

    def flag(key, bitmask)
      self.flags[key.to_sym] = bitmask
      reader   = :"#{key}"
      reader_q = :"#{key}?"
      writer   = :"#{key}="

      define_method(reader) do
        bits = self.send(self.class.flag_column_reader)
        (bits & bitmask) == bitmask
      end
      alias_method reader_q, reader

      define_method(writer) do |object|
        bits = self.send(self.class.flag_column_reader)
        case object
        when '0', 0, false
          bits &= ~bitmask
        when '1', 1, true
          bits |= bitmask
        end
        self.send(self.class.flag_column_writer, bits)
      end
    end
  end
end