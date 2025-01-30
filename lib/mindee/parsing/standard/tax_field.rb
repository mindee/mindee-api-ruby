# frozen_string_literal: true

require_relative 'base_field'

module Mindee
  module Parsing
    module Standard
      # Represents tax information.
      class TaxField < BaseField
        # Tax value as 3 decimal float
        # @return [Float, nil]
        attr_reader :value
        # Tax rate percentage
        # @return [Float]
        attr_reader :rate
        # Tax code
        # @return [String]
        attr_reader :code
        # Tax base
        # @return [Float]
        attr_reader :base

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @value = prediction['value']&.round(3)
          @rate = prediction['rate'].to_f unless prediction['rate'].nil?
          @base = prediction['base'].to_f unless prediction['base'].nil?
          @code = prediction['code'] unless prediction['code'] == 'None'
        end

        # @param value [Float]
        def print_float(value)
          format('%.2f', value)
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << ("Base: #{printable[:base]}")
          out_str << (", Code: #{printable[:code]}")
          out_str << (", Rate (%): #{printable[:rate]}")
          out_str << (", Amount: #{printable[:value]}")
          out_str.strip
        end

        # @return [Hash]
        def printable_values
          out_h = {}
          out_h[:code] = @code.nil? ? '' : @code
          out_h[:base] = @base.nil? ? '' : print_float(@base)
          out_h[:rate] = @rate.nil? ? '' : print_float(@rate).to_s
          out_h[:value] = @value.nil? ? '' : print_float(@value).to_s
          out_h
        end

        # @return [String]
        def to_table_line
          printable = printable_values
          out_str = String.new
          out_str << ("| #{printable[:base].ljust(13, ' ')}")
          out_str << (" | #{printable[:code].ljust(6, ' ')}")
          out_str << (" | #{printable[:rate].ljust(8, ' ')}")
          out_str << (" | #{printable[:value].ljust(13, ' ')} |")
          out_str.strip
        end
      end

      # Represents tax information, grouped as an array.
      class Taxes < Array
        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super(prediction.map { |entry| TaxField.new(entry, page_id) })
        end

        # @param char [String]
        # @return [String]
        def line_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 15}"
          out_str << "+#{char * 8}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 15}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def to_s
          return '' if nil? || empty?

          out_str = String.new
          out_str << ("\n#{line_separator('-')}")
          out_str << "\n  | Base          | Code   | Rate (%) | Amount        |"
          out_str << "\n#{line_separator('=')}"
          each do |entry|
            out_str << "\n  #{entry.to_table_line}\n#{line_separator('-')}"
          end
          out_str
        end
      end
    end
  end
end
