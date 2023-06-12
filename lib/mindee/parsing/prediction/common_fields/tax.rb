# frozen_string_literal: true

require_relative 'base'

module Mindee
  # Represents tax information.
  class TaxField < Field
    # Tax value as 3 decimal float
    # @return [Float]
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
      @value = @value.round(3) unless @value.nil?
      @rate = prediction['rate'].to_f unless prediction['rate'].nil?
      @base = prediction['base'].to_f unless prediction['base'].nil?
      @code = prediction['code'] unless prediction['code'] == 'None'
    end

    # @param value [Float]
    def print_float(value)
      format('%.2f', value)
    end

    def to_s
      printable = printable_values()
      out_str = String.new
      out_str << "Base: " + printable[:base]
      out_str << ", Code: " + printable[:code]
      out_str << ", Rate (%): " + printable[:rate]
      out_str << ", Amount: " + printable[:value]
      out_str.strip
    end

    def printable_values
      out_h = Hash.new
      out_h[:code] = @code.nil? ? "" : @code
      out_h[:base] = @base.nil? ? "" : @base.to_s
      out_h[:rate] = @rate.nil? ? "" : print_float(@rate).to_s
      out_h[:value] = @value.nil? ? "" : print_float(@value).to_s
      out_h
    end
    
    def to_table_line
        printable = self.printable_values
        out_str = String.new
        out_str << "| " + printable[:base].ljust(13, " ")
        out_str << " | " + printable[:code].ljust(6, " ")
        out_str << " | " + printable[:rate].ljust(8, " ")
        out_str << " | " + printable[:value].ljust(13, " ") + " |"
        out_str.strip
    end
  end

  class Taxes < Array
    # @param prediction [Hash]
    # @param page_id [Integer, nil]
    def initialize(prediction, page_id)
      prediction.each do |entry|
        self.push(TaxField.new(entry, page_id))
      end
      self
    end

    # @param char [String]
    def line_separator(char)
      out_str = String.new
      out_str << "  "
      out_str << "+#{char * 15}"
      out_str << "+#{char * 8}"
      out_str << "+#{char * 10}"
      out_str << "+#{char * 15}"
      out_str << "+"
      out_str
    end

    def to_s()
      out_str = String.new
      out_str << "\n"+self.line_separator("-")
      out_str << "\n  | Base          | Code   | Rate (%) | Amount        |"
      out_str << "\n#{self.line_separator("=")}"
      self.each do |entry|
        out_str << "\n  #{entry.to_table_line}\n#{self.line_separator("-")}"
      end
      out_str
    end
    

  end
end
