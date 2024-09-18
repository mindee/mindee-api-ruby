# frozen_string_literal: true

require_relative '../../../parsing'

module Mindee
  module Product
    module FR
      module EnergyBill
        # Details of energy consumption.
        class EnergyBillV1EnergyUsage < Mindee::Parsing::Standard::FeatureField
          include Mindee::Parsing::Standard
          # Description or details of the energy usage.
          # @return [String]
          attr_reader :description
          # The end date of the energy usage.
          # @return [String]
          attr_reader :end_date
          # The start date of the energy usage.
          # @return [String]
          attr_reader :start_date
          # The rate of tax applied to the total cost.
          # @return [Float]
          attr_reader :tax_rate
          # The total cost of energy consumed.
          # @return [Float]
          attr_reader :total
          # The price per unit of energy consumed.
          # @return [Float]
          attr_reader :unit_price

          # @param prediction [Hash]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            super(prediction, page_id)
            @description = prediction['description']
            @end_date = prediction['end_date']
            @start_date = prediction['start_date']
            @tax_rate = prediction['tax_rate']
            @total = prediction['total']
            @unit_price = prediction['unit_price']
            @page_id = page_id
          end

          # @return [Hash]
          def printable_values
            printable = {}
            printable[:description] = format_for_display(@description, 36)
            printable[:end_date] = format_for_display(@end_date, 10)
            printable[:start_date] = format_for_display(@start_date, nil)
            printable[:tax_rate] = @tax_rate.nil? ? '' : Field.float_to_string(@tax_rate)
            printable[:total] = @total.nil? ? '' : Field.float_to_string(@total)
            printable[:unit_price] = @unit_price.nil? ? '' : Field.float_to_string(@unit_price)
            printable
          end

          # @return [String]
          def to_table_line
            printable = printable_values
            out_str = String.new
            out_str << format('| %- 37s', printable[:description])
            out_str << format('| %- 11s', printable[:end_date])
            out_str << format('| %- 11s', printable[:start_date])
            out_str << format('| %- 9s', printable[:tax_rate])
            out_str << format('| %- 10s', printable[:total])
            out_str << format('| %- 11s', printable[:unit_price])
            out_str << '|'
          end

          # @return [String]
          def to_s
            printable = printable_values
            out_str = String.new
            out_str << "\n  :Description: #{printable[:description]}"
            out_str << "\n  :End Date: #{printable[:end_date]}"
            out_str << "\n  :Start Date: #{printable[:start_date]}"
            out_str << "\n  :Tax Rate: #{printable[:tax_rate]}"
            out_str << "\n  :Total: #{printable[:total]}"
            out_str << "\n  :Unit Price: #{printable[:unit_price]}"
            out_str
          end
        end
      end
    end
  end
end
