# frozen_string_literal: true

require 'date'

module Mindee
  class Field
    attr_reader :value,
                :confidence,
                :bbox,
                :polygon

    def initialize(prediction)
      @value = prediction['value']
      @confidence = prediction['confidence']
      @bbox = prediction['polygon']
      @polygon = prediction['polygon']
    end

    def to_s
      @value ? @value.to_s : ''
    end
  end

  class TypedField < Field
    attr_reader :type
  end

  class DateField < Field
    attr_reader :date_object

    def initialize(prediction)
      super
      @date_object = Date.parse(@value) if @value
    end
  end

  class Locale
    attr_reader :confidence,
                :language,
                :country,
                :currency

    def initialize(prediction)
      @confidence = prediction['confidence']
      @language = prediction['language']
      @country = prediction['country']
      @currency = prediction['currency']
    end

    def to_s
      "#{@language} #{@currency} #{@country}"
    end
  end

  class Tax < Field
    attr_reader :rate,
                :code

    def initialize(prediction)
      super
      @rate = prediction['rate']
      @code = prediction['codek']
    end

    def to_s
      "#{@value} #{@rate}% #{@code}"
    end
  end

  class PaymentDetails < Field
    attr_reader :account_number,
                :iban,
                :routing_number,
                :swift
  end
end
