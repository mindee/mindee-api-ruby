# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'passport_v1_document'

module Mindee
  module Product
    module Passport
      # Passport API version 1.1 page data.
      class PassportV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super(prediction)
          @prediction = PassportV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Passport V1 page prediction.
      class PassportV1PagePrediction < PassportV1Document
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
