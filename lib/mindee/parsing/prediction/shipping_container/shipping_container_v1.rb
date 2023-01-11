# frozen_string_literal: true

require_relative '../common_fields'
require_relative '../base'

module Mindee
  module Prediction
    # License plate prediction.
    class ShippingContainerV1 < Prediction
      # ISO 6346 code for container owner prefix + equipment identifier.
      # @return [Array<Mindee::TextField>]
      attr_reader :owner
      # ISO 6346 code for container serial number (6+1 digits).
      # @return [Array<Mindee::TextField>]
      attr_reader :serial_number
      # ISO 6346 code for container length, height and type.
      # @return [Array<Mindee::TextField>]
      attr_reader :size_type

      # @param prediction [Hash]
      # @param page_id [Integer, nil]
      def initialize(prediction, page_id)
        super
        @owner = TextField.new(prediction['owner'], page_id)
        @serial_number = TextField.new(prediction['serial_number'], page_id)
        @size_type = TextField.new(prediction['size_type'], page_id)
      end

      def to_s
        out_str = String.new
        out_str << "\n:Owner: #{@owner}".rstrip
        out_str << "\n:Serial number: #{@serial_number}".rstrip
        out_str << "\n:Size and type: #{@size_type}".rstrip
        out_str[1..].to_s
      end
    end
  end
end
