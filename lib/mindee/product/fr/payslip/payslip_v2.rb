# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'payslip_v2_document'
require_relative 'payslip_v2_page'

module Mindee
  module Product
    module FR
      # Payslip module.
      module Payslip
        # Payslip API version 2 inference prediction.
        class PayslipV2 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'payslip_fra'
          @endpoint_version = '2'
          @has_async = true
          @has_sync = false

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = PayslipV2Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(PayslipV2Page.new(page))
            end
          end

          class << self
            # Name of the endpoint for this product.
            # @return [String]
            attr_reader :endpoint_name
            # Version for this product.
            # @return [String]
            attr_reader :endpoint_version
            # Whether this product has access to an asynchronous endpoint.
            # @return [bool]
            attr_reader :has_async
            # Whether this product has access to synchronous endpoint.
            # @return [bool]
            attr_reader :has_sync
          end
        end
      end
    end
  end
end
