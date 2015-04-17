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
        self.root_symbol = opts[:root_symbol] || "$"
        self.mode = opts[:mode] || Json::Deflator::Modes::JPath
        self.enable_filters = true
        self.preserve_arrays = true
      end

    end

  end
end
