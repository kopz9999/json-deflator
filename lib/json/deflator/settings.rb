module Json
  module Deflator

    # Settings object
    class Settings

      attr_accessor :root_symbol
      attr_accessor :mode
      attr_accessor :preserve_arrays

      alias :preserve_arrays? :preserve_arrays

      def initialize( opts = {} )
        preserve_arrays_value = opts[:preserve_arrays]
        self.root_symbol = opts[:root_symbol] || "$"
        self.mode = opts[:mode] || Json::Deflator::Modes::JPath
        self.preserve_arrays = preserve_arrays_value.nil? ?
          true : preserve_arrays_value
      end

    end

  end
end
