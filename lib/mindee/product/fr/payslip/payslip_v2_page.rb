# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'payslip_v2_document'

module Mindee
  module Product
    module FR
      module Payslip
        # Payslip API version 2.0 page data.
        class PayslipV2Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = PayslipV2PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Payslip V2 page prediction.
        class PayslipV2PagePrediction < PayslipV2Document
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
