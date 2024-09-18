# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module EnergyBill
        # Information about the energy meter.
        class EnergyBillV1MeterDetail < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # The unique identifier of the energy meter.
          # @return [String]
          attr_reader :meter_number
          # The type of energy meter.
          # @return [String]
          attr_reader :meter_type
          # The unit of measurement for energy consumption, which can be kW, m³, or L.
          # @return [String]
          attr_reader :unit

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @meter_number = prediction['meter_number']
            @meter_type = prediction['meter_type']
            @unit = prediction['unit']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:meter_number] = format_for_display(@meter_number)
            printable[:meter_type] = format_for_display(@meter_type)
            printable[:unit] = format_for_display(@unit)
            printable
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Meter Number: #{printable[:meter_number]}"
            out_str << "\n  :Meter Type: #{printable[:meter_type]}"
            out_str << "\n  :Unit of Measure: #{printable[:unit]}"
            out_str
          end
        end
      end
    end
  end
end
