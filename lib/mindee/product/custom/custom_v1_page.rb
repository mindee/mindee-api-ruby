# frozen_string_literal: true

require_relative 'custom_v1_document'

module Mindee
  module Product
    # Custom document object.
    class CustomV1Page < CustomV1Document
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
