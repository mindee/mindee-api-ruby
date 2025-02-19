# frozen_string_literal: true

require_relative '../../parsing'

module Mindee
  module Product
    module BillOfLading
      # The shipping company responsible for transporting the goods.
      class BillOfLadingV1Carrier < Mindee::Parsing::Standard::FeatureField
        include Mindee::Parsing::Standard
        # The name of the carrier.
        # @return [String]
        attr_reader :name
        # The professional number of the carrier.
        # @return [String]
        attr_reader :professional_number
        # The Standard Carrier Alpha Code (SCAC) of the carrier.
        # @return [String]
        attr_reader :scac

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super
          @name = prediction['name']
          @professional_number = prediction['professional_number']
          @scac = prediction['scac']
          @page_id = page_id
        end

        # @return [Hash]
        def printable_values
          printable = {}
          printable[:name] = format_for_display(@name)
          printable[:professional_number] = format_for_display(@professional_number)
          printable[:scac] = format_for_display(@scac)
          printable
        end

        # @return [String]
        def to_s
          printable = printable_values
          out_str = String.new
          out_str << "\n  :Name: #{printable[:name]}"
          out_str << "\n  :Professional Number: #{printable[:professional_number]}"
          out_str << "\n  :SCAC: #{printable[:scac]}"
          out_str
        end
      end
    end
  end
end
