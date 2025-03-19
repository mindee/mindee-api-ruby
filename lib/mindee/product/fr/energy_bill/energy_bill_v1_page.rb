# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'energy_bill_v1_document'

module Mindee
  module Product
    module FR
      module EnergyBill
        # Energy Bill API version 1.2 page data.
        class EnergyBillV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = if prediction['prediction'].empty?
                            nil
                          else
                            EnergyBillV1PagePrediction.new(
                              prediction['prediction'],
                              prediction['id']
                            )
                          end
          end
        end

        # Energy Bill V1 page prediction.
        class EnergyBillV1PagePrediction < EnergyBillV1Document
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
