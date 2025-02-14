# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module US
      module HealthcareCard
        # Is a fixed amount for a covered service.
        class HealthcareCardV1Copay < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The price of service.
          # @return [Float]
          attr_reader :service_fees
          # The name of service of the copay.
          # @return [String]
          attr_reader :service_name

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super
            @service_fees = prediction['service_fees']
            @service_name = prediction['service_name']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:service_fees] =
              @service_fees.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@service_fees)
            printable[:service_name] = format_for_display(@service_name)
            printable
          end

          # @return [Hash]
          def table_printable_values
            printable = {}
            printable[:service_fees] =
              @service_fees.nil? ? '' : Parsing::Standard::BaseField.float_to_string(@service_fees)
            printable[:service_name] = format_for_display(@service_name, nil)
            printable
          end

          # @return [String]
          def to_table_line
            printable = table_printable_values
            out_str = String.new
            out_str << format('| %- 13s', printable[:service_fees])
            out_str << format('| %- 13s', printable[:service_name])
            out_str << '|'
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Service Fees: #{printable[:service_fees]}"
            out_str << "\n  :Service Name: #{printable[:service_name]}"
            out_str
          end
        end
      end
    end
  end
end
