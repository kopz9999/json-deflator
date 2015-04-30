module Json
  module Deflator

    # Settings object
    class Settings

      attr_accessor :root_symbol
      attr_accessor :mode
      attr_accessor :enable_filters
      attr_accessor :preserve_arrays

      alias :enable_filters? :enable_filters
      alias :preserve_arrays? :preserve_arrays

      def initialize( opts = {} )
        enable_filters_value = opts[:enable_filters]
        preserve_arrays_value = opts[:preserve_arrays]
        self.root_symbol = opts[:root_symbol] || "$"
        self.mode = opts[:mode] || Json::Deflator::Modes::JPath
        self.enable_filters = enable_filters_value.nil? ? 
          true : enable_filters_value
        self.preserve_arrays = preserve_arrays_value.nil? ?
          true : preserve_arrays_value
      end

    end

  end
end
