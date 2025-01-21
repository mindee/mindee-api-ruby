# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'proof_of_address_v1_document'

module Mindee
  module Product
    module ProofOfAddress
      # Proof of Address API version 1.1 page data.
      class ProofOfAddressV1Page < Mindee::Parsing::Common::Page
        # @param prediction [Hash]
        def initialize(prediction)
          super
          @prediction = ProofOfAddressV1PagePrediction.new(
            prediction['prediction'],
            prediction['id']
          )
        end
      end

      # Proof of Address V1 page prediction.
      class ProofOfAddressV1PagePrediction < ProofOfAddressV1Document
        # @return [String]
        def to_s
          out_str = String.new
          out_str << "\n#{super}"
          out_str
        end
      end
    end
  end
end
