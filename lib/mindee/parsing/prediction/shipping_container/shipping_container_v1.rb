# frozen_string_literal: true

module Mindee
  module Prediction
    # License plate prediction.
    class ShippingContainer < Prediction
      # @return [Array<Mindee::TextField>]
      attr_reader :owner
      # @return [Array<Mindee::TextField>]
      attr_reader :serial_number
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