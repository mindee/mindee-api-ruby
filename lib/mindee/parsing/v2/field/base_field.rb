# frozen_string_literal: true

module Mindee
  module Parsing
    module V2
      module Field
        # Base class for V2 fields.
        class BaseField
          # @return [Integer] Level of indentation for rst display.
          attr_reader :indent_level

          # @return [FieldConfidence, nil] Confidence score for the field.
          attr_reader :confidence

          # @return [Array<FieldLocation>] List of locations the field was found at.
          attr_reader :locations

          # @param raw_prediction [Hash] Raw prediction hash.
          # @param indent_level [Integer] Level of indentation for rst display.
          def initialize(raw_prediction, indent_level = 0)
            @indent_level = indent_level
            @confidence = raw_prediction.key?('confidence') ? raw_prediction['confidence'] : nil
            @locations = if raw_prediction.key?('locations')
                           raw_prediction['locations'].map do |location|
                             FieldLocation.new(location)
                           end
                         else
                           []
                         end
          end

          # Factory method to create appropriate field types.
          # @param raw_prediction [Hash] Raw prediction hash.
          # @param indent_level [Integer] Level of indentation for rst display.
          # @return [BaseField] Appropriate field instance.
          # @raise [MindeeError] If the field type isn't recognized.
          def self.create_field(raw_prediction, indent_level = 0)
            if raw_prediction.key?('items')
              require_relative 'list_field'
              return ListField.new(raw_prediction, indent_level)
            end

            if raw_prediction.key?('fields')
              require_relative 'object_field'
              return ObjectField.new(raw_prediction, indent_level)
            end

            if raw_prediction.key?('value')
              require_relative 'simple_field'
              return SimpleField.new(raw_prediction, indent_level)
            end

            raise Errors::MindeeError, "Unrecognized field format in #{raw_prediction.to_json}"
          end
        end
      end
    end
  end
end
