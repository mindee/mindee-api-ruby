# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'indian_passport_v1_document'

module Mindee
  module Product
    module IND
      module IndianPassport
        # Passport - India API version 1.2 page data.
        class IndianPassportV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = IndianPassportV1PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Passport - India V1 page prediction.
        class IndianPassportV1PagePrediction < IndianPassportV1Document
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
end
