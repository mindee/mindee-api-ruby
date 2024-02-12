# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'generated_v1_prediction'

module Mindee
  module Product
    module Generated
      # Generated Document V1 prediction
      class GeneratedV1Document < Mindee::Product::Generated::GeneratedV1Prediction
        include Mindee::Parsing::Standard
        # @param raw_prediction [Hash]
        def initialize(raw_prediction)
          # Generated document.

          # raw_prediction: Dictionary containing the JSON document response
          super()
          raw_prediction.each do |field_name, field_contents|
            if field_contents.is_a?(Array)
              @fields[field_name] = Parsing::Generated::GeneratedListField.new(field_contents)
            elsif field_contents.is_a?(Hash) && Parsing::Generated.generated_object?(field_contents)
              @fields[field_name] = Parsing::Generated::GeneratedObjectField.new(field_contents)
            else
              field_contents_str = field_contents.dup
              if field_contents_str.key?('value') && field_contents_str['value'].nil? == false
                field_contents_str['value'] = field_contents_str['value'].to_s
              end
              @fields[field_name] = StringField.new(field_contents_str)
            end
          end
        end
      end
    end
  end
end
