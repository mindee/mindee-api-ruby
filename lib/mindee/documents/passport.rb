# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
  class Passport < Document
    attr_reader :country

    def initialize(response)
      super()
      prediction = response['document']['inference']['prediction']
      @country = Field.new(prediction['country'])
    end

    def to_s
      "-----Passport data-----\n" \
        '----------------------'
    end
  end
end
