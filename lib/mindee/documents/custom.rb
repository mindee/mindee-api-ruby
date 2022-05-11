# frozen_string_literal: true

require_relative '../fields'
require_relative 'base'

module Mindee
  class CustomDocument < Document
    attr_reader :fields

    def initialize(response, document_type)
      super(document_type)
      response.each do |field_name, field_data|
        puts field_name, field_data
      end
    end

    def to_s
      "-----Receipt data-----\n" \
        '----------------------'
    end
  end
end
