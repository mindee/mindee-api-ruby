# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'bank_check_v1_document'
require_relative 'bank_check_v1_page'

module Mindee
  module Product
    module US
      # Bank Check module.
      module BankCheck
        # Bank Check API version 1 inference prediction.
        class BankCheckV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'bank_check'
          @endpoint_version = '1'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = BankCheckV1Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
                @pages.push(BankCheckV1Page.new(page))
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
