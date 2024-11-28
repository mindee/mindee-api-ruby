# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'payslip_v3_document'

module Mindee
  module Product
    module FR
      module Payslip
        # Payslip API version 3.0 page data.
        class PayslipV3Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super(prediction)
            @prediction = PayslipV3PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Payslip V3 page prediction.
        class PayslipV3PagePrediction < PayslipV3Document
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
