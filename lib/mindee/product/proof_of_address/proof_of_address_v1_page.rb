# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'proof_of_address_v1_document'

module Mindee
  module Product
    module ProofOfAddress
      # Proof of Address V1 document prediction.
      class ProofOfAddressV1Page < ProofOfAddressV1Document
        include Mindee::Parsing::Common
        # @return [Integer]
        attr_reader :page_id
        # @return [Mindee::Parsing::Common::Orientation]
        attr_reader :orientation

        def initialize(http_response)
          @page_id = http_response['id']
          @orientation = Orientation.new(http_response['orientation'], @page_id)
          super(http_response['prediction'], @page_id)
        end

        # @return [String]
        def to_s
          out_str = String.new
          title = "Page #{@page_id}"
          out_str << "#{title}\n"
          out_str << ('-' * title.size)
          out_str << "\n#{super}"
          out_str
        end
      end
    end
  end
end
