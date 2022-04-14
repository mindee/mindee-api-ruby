# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
  class FinancialDocument < Document
    def to_s
      "-----Financial Document data-----\n"\
        '----------------------'
    end
  end
end
