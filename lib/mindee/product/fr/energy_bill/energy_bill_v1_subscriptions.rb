# frozen_string_literal: true

require_relative 'energy_bill_v1_energy_supplier'
require_relative 'energy_bill_v1_energy_consumer'
require_relative 'energy_bill_v1_subscription'
require_relative 'energy_bill_v1_energy_usage'
require_relative 'energy_bill_v1_taxes_and_contribution'
require_relative 'energy_bill_v1_meter_detail'

module Mindee
  module Product
    module FR
      module EnergyBill
        # The subscription details fee for the energy service.
        class EnergyBillV1Subscriptions < Array
          # Entries.
          # @return [Array<EnergyBillV1Subscription>]
          attr_reader :entries

          # @param prediction [Array]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            entries = prediction.map do |entry|
              EnergyBill::EnergyBillV1Subscription.new(entry, page_id)
            end
            super(entries)
          end

          # Creates a line of rST table-compliant string separators.
          # @param char [String] Character to use as a separator.
          # @return [String]
          def self.line_items_separator(char)
            out_str = String.new
            out_str << "+#{char * 38}"
            out_str << "+#{char * 12}"
            out_str << "+#{char * 12}"
            out_str << "+#{char * 10}"
            out_str << "+#{char * 11}"
            out_str << "+#{char * 12}"
            out_str
          end

          # @return [String]
          def to_s
            return '' if empty?

            lines = map do |entry|
              "\n  #{entry.to_table_line}\n#{self.class.line_items_separator('-')}"
            end.join
            out_str = String.new
            out_str << "\n#{self.class.line_items_separator('-')}\n "
            out_str << ' | Description                         '
            out_str << ' | End Date  '
            out_str << ' | Start Date'
            out_str << ' | Tax Rate'
            out_str << ' | Total    '
            out_str << ' | Unit Price'
            out_str << " |\n#{self.class.line_items_separator('=')}"
            out_str + lines
          end
        end
      end
    end
  end
end
