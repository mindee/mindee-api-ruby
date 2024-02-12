# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'generated_v1_prediction'

module Mindee
  module Product
    module Generated
      # Generated Document V1 page.
      class GeneratedV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super(prediction)
          @prediction = GeneratedV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Generated Document V1 page prediction.
      class GeneratedV1PagePrediction < GeneratedV1Prediction
        include Mindee::Parsing::Standard
        include Mindee::Parsing::Generated
        def initialize(raw_prediction, page_id = nil)
          super()
          raw_prediction.each do |field_name, field_contents|
            if field_contents.is_a?(Array)
              @fields[field_name] = GeneratedListField.new(field_contents, page_id)
            elsif field_contents.is_a?(Hash) && generated_object?(field_contents)
              @fields[field_name] = GeneratedObjectField.new(field_contents, page_id)
            else
              field_contents_str = field_contents.dup
              if field_contents_str.key?('value') && !field_contents_str['value'].nil?
                field_contents_str['value'] = field_contents_str['value'].to_s
              end
              @fields[field_name] = StringField.new(field_contents_str, page_id: page_id)
            end
          end
        end

        # @return [String]
        def to_s
          out_str = String.new
          out_str << "\n#{super}"
          out_str
        end
      end
    end
  end
end
