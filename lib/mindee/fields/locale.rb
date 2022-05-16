# frozen_string_literal: true

module Mindee
  class Locale
    attr_reader :confidence,
                :language,
                :country,
                :currency

    def initialize(prediction)
      @confidence = prediction['confidence']
      @value = prediction['value']
      @language = prediction['language']
      @country = prediction['country']
      @currency = prediction['currency']
    end

    def to_s
      out_str = String.new
      out_str << "#{@value}; " if @value
      out_str << "#{@language}; " if @language
      out_str << "#{@country}; " if @country
      out_str << "#{@currency}; " if @currency
      out_str.strip
    end
  end
end
