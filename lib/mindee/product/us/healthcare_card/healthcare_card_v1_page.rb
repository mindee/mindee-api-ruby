# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'healthcare_card_v1_document'

module Mindee
  module Product
    module US
      module HealthcareCard
        # Healthcare Card API version 1.2 page data.
        class HealthcareCardV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = if prediction['prediction'].empty?
                            nil
                          else
                            HealthcareCardV1PagePrediction.new(
                              prediction['prediction'],
                              prediction['id']
                            )
                          end
          end
        end

        # Healthcare Card V1 page prediction.
        class HealthcareCardV1PagePrediction < HealthcareCardV1Document
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
