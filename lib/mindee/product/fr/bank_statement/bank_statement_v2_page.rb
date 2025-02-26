# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_statement_v2_document'

module Mindee
  module Product
    module FR
      module BankStatement
        # Bank Statement API version 2.0 page data.
        class BankStatementV2Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super(prediction)
            @prediction = BankStatementV2PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Bank Statement V2 page prediction.
        class BankStatementV2PagePrediction < BankStatementV2Document
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
