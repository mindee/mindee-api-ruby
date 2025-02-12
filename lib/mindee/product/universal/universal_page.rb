# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'universal_prediction'

module Mindee
  module Product
    module Universal
      # Universal Document V1 page.
      class UniversalPage < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = UniversalPagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Universal Document V1 page prediction.
      class UniversalPagePrediction < UniversalPrediction
        include Mindee::Parsing::Standard
        include Mindee::Parsing::Universal
        def initialize(raw_prediction, page_id = nil)
          super(raw_prediction)
          raw_prediction.each do |field_name, field_contents|
            if field_contents.is_a?(Array)
              @fields[field_name] = Mindee::Parsing::Universal::UniversalListField.new(field_contents, page_id)
            elsif field_contents.is_a?(Hash) && Parsing::Universal.universal_object?(field_contents)
              @fields[field_name] = Mindee::Parsing::Universal::UniversalObjectField.new(field_contents, page_id)
            else
              field_contents_str = field_contents.dup
              if field_contents_str.key?('value') && !field_contents_str['value'].nil?
                field_contents_str['value'] = field_contents_str['value'].to_s
              end
              @fields[field_name] = Mindee::Parsing::Standard::StringField.new(field_contents_str, page_id)
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
