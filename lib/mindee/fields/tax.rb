# frozen_string_literal: true

require_relative 'base'

module Mindee
  # Represents tax information.
  class Tax < Field
    # Tax value as 3 decimal float
    # @return [Float]
    attr_reader :value
    # Tax rate percentage
    # @return [Float]
    attr_reader :rate
    # Tax code
    # @return [String]
    attr_reader :code

    def initialize(prediction, page_id)
      super
      @value = @value.round(3) unless @value.nil?
      @rate = prediction['rate'].to_f unless prediction['rate'].nil?
      @code = prediction['code'] unless prediction['code'] == 'None'
    end

    def to_s
      out_str = String.new
      out_str << "#{@value} " if @value
      out_str << "#{@rate}% " if @rate
      out_str << "#{@code} " if @code
      out_str.strip
    end
  end
end
