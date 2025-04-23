# frozen_string_literal: true

require_relative 'healthcare_card_v1_copay'

module Mindee
  module Product
    module US
      module HealthcareCard
        # Is a fixed amount for a covered service.
        class HealthcareCardV1Copays < Array
          # Entries.
          # @return [Array<HealthcareCardV1Copay>]
          attr_reader :entries

          # @param prediction [Array]
          # @param page_id [Integer, nil]
          def initialize(prediction, page_id)
            entries = prediction.map do |entry|
              HealthcareCard::HealthcareCardV1Copay.new(entry, page_id)
            end
            super(entries)
          end

          # Creates a line of rST table-compliant string separators.
          # @param char [String] Character to use as a separator.
          # @return [String]
          def self.line_items_separator(char)
            out_str = String.new
            out_str << "+#{char * 14}"
            out_str << "+#{char * 22}"
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
            out_str << ' | Service Fees'
            out_str << ' | Service Name        '
            out_str << " |\n#{self.class.line_items_separator('=')}"
            out_str + lines
          end
        end
      end
    end
  end
end
