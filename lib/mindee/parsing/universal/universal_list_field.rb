# frozen_string_literal: true

require_relative 'universal_object_field'

module Mindee
  module Parsing
    module Universal
      # A list of values or objects, used in universal APIs.
      class UniversalListField
        include Mindee::Parsing::Standard
        include Mindee::Parsing::Universal

        # ID of the page (as given by the API).
        # @return [Integer]
        attr_accessor :page_id

        # List of word values
        # @return [Array<UniversalObjectField, StringField>]
        attr_accessor :values

        # ID of the page the object was found on.
        # List of word values.

        def initialize(raw_prediction, page_id = nil)
          @values = []

          raw_prediction.each do |value|
            page_id = value['page_id'] if value.key?('page_id') && !value['page_id'].nil?

            if Universal.universal_object?(value)
              @values.push(UniversalObjectField.new(value, page_id))
            else
              value_str = value.dup
              value_str['value'] = value_str['value'].to_s if value_str.key?('value') && !value_str['value'].nil?
              @values.push(StringField.new(value_str, page_id))
            end
          end
        end

        # Return an Array of the contents of all values.
        # @return [Array<String>]
        def contents_list
          @values.map(&:to_s)
        end

        # Return a string representation of all values.
        def contents_string(separator = ' ')
          @values.map(&:to_s).join(separator)
        end

        # String representation
        def to_s
          contents_string
        end
      end
    end
  end
end
