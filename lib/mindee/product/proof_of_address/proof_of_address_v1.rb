# frozen_string_literal: true

require_relative 'proof_of_address_v1_document'

module Mindee
  module Product
    # Proof of Address v1 prediction results.
    class ProofOfAddressV1 < ProofOfAddressV1Document
      @endpoint_name = 'proof_of_address'
      @endpoint_version = '1'

      class << self
        attr_reader :endpoint_name, :endpoint_version
      end
    end
  end
end
