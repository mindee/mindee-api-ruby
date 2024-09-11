# frozen_string_literal: true

require_relative '../../standard/position_field'

module Mindee
  module Parsing
    module Common
      module Extras
        # Full Text OCR result.
        class FullTextOCRExtra
          # Contents of the full text OCR result.
          # @return [String, nil]
          attr_reader :contents
          # Language used on the page.
          # @return [String, nil]
          attr_reader :language

          def initialize(raw_prediction)
            @contents = raw_prediction['content'] if raw_prediction['content']
            return unless raw_prediction['language']

            @language = raw_prediction['language']
          end

          def to_s
            @contents || ''
          end
        end
      end
    end
  end
end
