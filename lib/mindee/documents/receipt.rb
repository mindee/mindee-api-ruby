# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
  class Receipt < Document
    attr_reader :locale

    def initialize(response)
      super()
      prediction = response['document']['inference']['prediction']
      @locale = Locale.new(prediction['locale'])
    end

    def to_s
      "-----Receipt data-----\n" \
        '----------------------'
    end
  end
end
