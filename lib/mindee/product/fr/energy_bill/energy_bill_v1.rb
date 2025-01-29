# frozen_string_literal: true

require_relative '../../../parsing'
require_relative 'energy_bill_v1_document'
require_relative 'energy_bill_v1_page'

module Mindee
  module Product
    module FR
      # Energy Bill module.
      module EnergyBill
        # Energy Bill API version 1 inference prediction.
        class EnergyBillV1 < Mindee::Parsing::Common::Inference
          @endpoint_name = 'energy_bill_fra'
          @endpoint_version = '1'

          # @param prediction [Hash]
          def initialize(prediction)
            super
            @prediction = EnergyBillV1Document.new(prediction['prediction'], nil)
            @pages = []
            prediction['pages'].each do |page|
              @pages.push(EnergyBillV1Page.new(page))
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
