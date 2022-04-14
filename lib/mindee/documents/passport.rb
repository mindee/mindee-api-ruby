# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
  class Passport < Document
    def to_s
      "-----Passport data-----\n" \
        '----------------------'
    end
  end
end
