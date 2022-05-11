# frozen_string_literal: true

require_relative 'base'

module Mindee
  class Tax < Field
    attr_reader :rate,
                :code

    def initialize(prediction, page_id)
      super
      @rate = prediction['rate']
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
