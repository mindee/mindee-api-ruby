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
      out_str = String.new
      out_str << "#{print_float(@value)} " if @value
      out_str << "#{print_float(@rate)}% " if @rate
      out_str << "#{@code} " if @code
      out_str.strip
    end
  end
end
