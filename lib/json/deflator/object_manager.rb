module Json
  module Deflator
    class ObjectManager

      # Modules
      module Keys
        Current = :current
      end

      module ClassMethods

        def current_instance
          Thread.current[ Keys::Current ]
        end

        def current_instance=(value)
          Thread.current[ Keys::Current ] = value
        end

      end

      # Mixins
      extend ClassMethods

      # Attribute Definition
      public
      # Settings
      attr_accessor :settings
      # Storing references
      attr_accessor :reference_tracker

      # Current Path. Only for JPath
      attr_accessor :current_path
      # Next JSON id. Only for Static Reference
      attr_accessor :current_identity

      def initialize( opts = {} )
        settings_value = opts[:settings]
        self.settings = settings_value.nil? ? 
          Json::Deflator.default_settings : Deflator::Settings.new(settings_value)
        self.reference_tracker = Hash.new
        case self.settings.mode
          when Json::Deflator::Modes::JPath
            self.current_path = self.settings.root_symbol
          when Json::Deflator::Modes::StaticReference
            self.current_identity = 0
        end
      end

      def next_identity
        self.current_identity += 1
      end

    end
  end
end