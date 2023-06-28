# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_check_v1_document'

module Mindee
  module Product
    module US
      module BankCheck
        # Bank Check V1 page.
        class BankCheckV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super(prediction)
            @prediction = BankCheckV1PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Bank Check V1 page prediction.
        class BankCheckV1PagePrediction < BankCheckV1Document
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
