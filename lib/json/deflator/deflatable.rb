module Json
  module Deflator
    module Deflatable

      # @opts =
      #   - :except = array of keys to exclude from object attributes
      #   - :only = array of keys to include from object attributes
      #   - :settings = 
      #     - instance of class Json::Deflator::Settings
      def deflate_json!(opts = {})
        if ObjectManager.current_instance.nil?
          # this means that there's no current iteration
          result = Thread.new do
            ObjectManager.current_instance = 
              ObjectManager.new( settings: opts.delete(:settings) )
            self.evaluate! opts
          end
          result.join
          result.value
        else
          # Keep iterating
          self.evaluate! opts
        end
      end

      protected

      def evaluate!( opts = {})
        case ObjectManager.current_instance.settings.mode
          when Json::Deflator::Modes::JPath
            return evaluate_deflate_jpath!( opts )
          when Json::Deflator::Modes::StaticReference
            return evaluate_deflate_static_reference!( opts )
        end
      end

      def deflate_jpath!( opts = {} )
        raise NotImplementedError
      end

      def deflate_static_reference!( opts = {} )
        raise NotImplementedError
      end

      private

      def evaluate_deflate_static_reference!( opts = {} )
        if self.is_a?(Array)
          return ObjectManager.current_instance.settings.preserve_arrays? ? 
            check_reference_for_static_reference!(opts) : 
              self.deflate_static_reference!( opts )
        else
          return check_reference_for_static_reference!(opts)
        end
      end

      # Store this one and solve circular references
      def check_reference_for_static_reference!( opts = {} )
        assert_recursion opts do | reference_id |
          identity = ObjectManager.current_instance.next_identity
          ObjectManager.current_instance.reference_tracker[ reference_id ] = identity
          result = self.deflate_static_reference!( opts )
          if self.is_a?(Array)
            { Json::Deflator::Identities::Values => result, 
              Json::Deflator::Identities::Identifier => identity }
          else
            # Opposite case is always a hash
            result[ Json::Deflator::Identities::Identifier ] = identity
            result
          end
        end    
      end

      def evaluate_deflate_jpath!( opts = {} )
        if self.is_a?(Array)
          return ObjectManager.current_instance.settings.preserve_arrays? ? 
            check_reference_for_jpath!(opts) : self.deflate_jpath!( opts )
        else
          return check_reference_for_jpath!(opts)
        end
      end

      # Store this one and solve circular references
      def check_reference_for_jpath!(opts)
        assert_recursion opts do | reference_id |
          ObjectManager.current_instance.reference_tracker[ reference_id ] = 
            ObjectManager.current_instance.current_path
          self.deflate_jpath!( opts )
        end
      end

      def assert_recursion( opts )
        # The reference identifier may come from an object delegated to a hash
        # Remove it and continue the iteration
        reference_id = opts[:object_id].nil? ? 
          self.object_id : opts.delete(:object_id)
        reference = ObjectManager.current_instance.reference_tracker[ reference_id ]
        if reference.blank?
          return yield( reference_id )
        else
          return { Json::Deflator::Identities::Reference => reference }
        end
      end

    end
  end
end