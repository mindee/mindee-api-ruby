# frozen_string_literal: true

module Mindee
  module Parsing
    module Standard
      # Represents locale information
      class Locale
        # The confidence score, value will be between 0.0 and 1.0
        # @return [Float]
        attr_reader :confidence
        #  Language code in ISO 639-1 format.
        # @return [String]
        attr_reader :language
        # Country code in ISO 3166-1 alpha-2 format.
        # @return [String, nil]
        attr_reader :country
        # Currency code in ISO 4217 format.
        # @return [String]
        attr_reader :currency
        # Language code, with country code when available.
        # @return [String]
        attr_reader :value

        # @param prediction [Hash]
        def initialize(prediction, _page_id = nil)
          value_key = if prediction.include? 'value'
                        'value'
                      else
                        'language'
                      end
          @confidence = prediction['confidence']
          @value = prediction[value_key]
          @language = prediction['language']
          @country = prediction['country']
          @currency = prediction['currency']
        end

        # @return [String]
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
  end
end
