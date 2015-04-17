module Json
  module Deflator
    class Parser

      # modules

      module Identities
        Reference = '$ref'
        Values = '$values'
        Identifier = '$id'
      end

      module Modes
        JPath = :j_path
        StaticReference = :static_reference
      end

      # Attribute Definition

      public

      # Autoincrement value to get the next id
      attr_accessor :next_identity

      # Storing references
      attr_accessor :reference_tracker

      # as_json opts
      attr_accessor :filter_options

      # Method Definition

      public

      def initialize( opts = {} )
        self.settings = Settings.new( opts[:settings] || {} )
        self.reference_tracker = Hash.new
        self.filter_options = opts[:filter_options] || {}
      end

      # This methods mutate the provided JSON
      def process!( original_value, mode = nil )
        self.settings.mode = mode unless mode.nil?
        case self.settings.mode
          when Modes::JPath
            return deflate_jpath!(original_value, self.settings.root_symbol)
          when Modes::StaticReference
            return deflate_static_reference! original_value
        end
      end

      # This methods mutate the provided JSON 
      def deflate_jpath!( original_value, json_path )
        case
          # Identify Basic data types
          when original_value.is_a?(String, Fixnum, NilClass, Symbol, 
            TrueClass, FalseClass)
            return original_value
          # Identify Arrays
          when original_value.is_a?(Array)
            original_value.map!.with_index do | obj, i |
              deflate_jpath!(obj, "#{ json_path }[#{ i }]" )
            end
          # Identify Objects
          else
            memory_reference = original_value.object_id
            if self.reference_tracker[ memory_reference ].nil?
              # Not tracked, then we start to serialize it
              self.reference_tracker[ memory_reference ] = json_path
              # Object to Hash
              hashed_value = original_value.responds_to?(:to_hash) ? 
                original_value.to_hash : original_value.instance_values
              filtered_hash = filter_hash( hashed_value )
              # Recursive step
              filtered_hash.each do | k, v |
                filtered_hash[ k ] = deflate_jpath!( v, "#{ json_path }.#{ k }")
              end
              return filtered_hash
            else
              return { Identities::Reference => 
                self.reference_tracker[ memory_reference ] }
            end
        end
        return original_value
      end

      def deflate_static_reference!( original_value )

      end

      def filter_hash( hash )
        if settings.enable_filters?
          if attrs = options[:only]
            hash.slice(*Array(attrs))
          elsif attrs = options[:except]
            hash.except(*Array(attrs))
          else
            hash
          end
        end
      end

    end
  end
end
