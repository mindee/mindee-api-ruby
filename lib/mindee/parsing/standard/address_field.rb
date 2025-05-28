# frozen_string_literal: true

require_relative 'string_field'

module Mindee
  module Parsing
    module Standard
      # Represents physical-address information.
      class AddressField < Mindee::Parsing::Standard::StringField
        # Street number
        # @return [String, nil]
        attr_reader :street_number
        # Street name
        # @return [String, nil]
        attr_reader :street_name
        # PO Box number
        # @return [String, nil]
        attr_reader :po_box
        # Address complement
        # @return [String, nil]
        attr_reader :address_complement
        #  City name.
        # @return [String, nil]
        attr_reader :city
        # Postal or ZIP code.
        # @return [String, nil]
        attr_reader :postal_code
        # State, province or region.
        # @return [String, nil]
        attr_reader :state
        # Country.
        # @return [String, nil]
        attr_reader :country

        def initialize(prediction, page_id = nil, reconstructed: false)
          super
          @street_number = prediction['street_number']
          @street_name = prediction['street_name']
          @po_box = prediction['po_box']
          @address_complement = prediction['address_complement']
          @city = prediction['city']
          @postal_code = prediction['postal_code']
          @state = prediction['state']
          @country = prediction['country']
        end
      end
    end
  end
end
