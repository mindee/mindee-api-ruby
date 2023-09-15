# frozen_string_literal: true

module Mindee
  module Parsing
    module Standard
      # Company registration number or code, and its type.
      class CompanyRegistrationField < Field
        # @return [String]
        attr_reader :type

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        # @param reconstructed [Boolean]
        def initialize(prediction, page_id, reconstructed: false)
          super
          @type = prediction['type']
        end
      end
    end
  end
end
