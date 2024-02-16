# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_statement_v1_document'
require_relative 'bank_statement_v1_page'

module Mindee
  module Product
    module FR
      # Bank Statement (FR) module.
      module BankStatement
        # Bank Statement (FR) V1 prediction inference.
        class BankStatementV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'bank_statement_fr'
          @endpoint_version = '1'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = BankStatementV1Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
                @pages.push(BankStatementV1Page.new(page))
              end
            end
          end

          class << self
            # Name of the endpoint for this product.
            # @return [String]
            attr_reader :endpoint_name
            # Version for this product.
            # @return [String]
            attr_reader :endpoint_version
          end
        end
      end
    end
  end
end
