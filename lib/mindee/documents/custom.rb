# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
  class CustomDocument < Document
    def to_s
      "-----Receipt data-----\n" \
        '----------------------'
    end
  end
end
