module Json
  module Deflator

    module Modes
      JPath = :j_path
      StaticReference = :static_reference
    end

    module Identities
      Reference = '$ref'
      Values = '$values'
      Identifier = '$id'
    end

    module ClassMethods

      def default_settings
        Settings.new
      end

    end

    extend ClassMethods

  end
end
