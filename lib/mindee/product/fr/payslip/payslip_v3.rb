# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'payslip_v3_document'
require_relative 'payslip_v3_page'

module Mindee
  module Product
    module FR
      # Payslip module.
      module Payslip
        # Payslip API version 3 inference prediction.
        class PayslipV3 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'payslip_fra'
          @endpoint_version = '3'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = PayslipV3Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              if page.key?('prediction') && !page['prediction'].nil? && !page['prediction'].empty?
                @pages.push(PayslipV3Page.new(page))
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
