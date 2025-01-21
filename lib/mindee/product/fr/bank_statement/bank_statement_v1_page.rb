# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_statement_v1_document'

module Mindee
  module Product
    module FR
      module BankStatement
        # Bank Statement (FR) V1 page.
        class BankStatementV1Page < Mindee::Parsing::Common::Page
          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = BankStatementV1PagePrediction.new(
              prediction['prediction'],
              prediction['id']
            )
          end
        end

        # Bank Statement (FR) V1 page prediction.
        class BankStatementV1PagePrediction < BankStatementV1Document
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
