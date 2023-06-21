# frozen_string_literal: true

require_relative 'custom_v1_document'

module Mindee
  module Product
    # Custom document object page.
    class CustomV1Page < CustomV1Document
      # @return [Integer]
      attr_reader :page_id
      # @return [Mindee::Orientation]
      attr_reader :orientation

      def initialize(http_response)
        @page_id = http_response['id']
        @orientation = Mindee::Parsing::Common::Orientation.new(http_response['orientation'], @page_id)
        super(http_response['prediction'], @page_id)
      end

      def to_s
        out_str = String.new
        @fields.each do |name, info|
          out_str << "\n:#{name}: #{info}".rstrip
        end
        out_str[1..].to_s
      end
    end
  end
end
