# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'bill_of_lading_v1_shipper'
require_relative 'bill_of_lading_v1_consignee'
require_relative 'bill_of_lading_v1_notify_party'
require_relative 'bill_of_lading_v1_carrier'
require_relative 'bill_of_lading_v1_carrier_item'

module Mindee
  module Product
    module BillOfLading
      # Bill of Lading API version 1.1 document data.
      class BillOfLadingV1Document < Mindee::Parsing::Common::Prediction
        include Mindee::Parsing::Standard
        # A unique identifier assigned to a Bill of Lading document.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :bill_of_lading_number
        # The shipping company responsible for transporting the goods.
        # @return [Mindee::Product::BillOfLading::BillOfLadingV1Carrier]
        attr_reader :carrier
        # The goods being shipped.
        # @return [Array<Mindee::Product::BillOfLading::BillOfLadingV1CarrierItem>]
        attr_reader :carrier_items
        # The party to whom the goods are being shipped.
        # @return [Mindee::Product::BillOfLading::BillOfLadingV1Consignee]
        attr_reader :consignee
        # The date when the bill of lading is issued.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :date_of_issue
        # The date when the vessel departs from the port of loading.
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :departure_date
        # The party to be notified of the arrival of the goods.
        # @return [Mindee::Product::BillOfLading::BillOfLadingV1NotifyParty]
        attr_reader :notify_party
        # The place where the goods are to be delivered.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :place_of_delivery
        # The port where the goods are unloaded from the vessel.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :port_of_discharge
        # The port where the goods are loaded onto the vessel.
        # @return [Mindee::Parsing::Standard::StringField]
        attr_reader :port_of_loading
        # The party responsible for shipping the goods.
        # @return [Mindee::Product::BillOfLading::BillOfLadingV1Shipper]
        attr_reader :shipper

        # @param prediction [Hash]
        # @param page_id [Integer, nil]
        def initialize(prediction, page_id)
          super()
          @bill_of_lading_number = StringField.new(prediction['bill_of_lading_number'], page_id)
          @carrier = BillOfLadingV1Carrier.new(prediction['carrier'], page_id)
          @carrier_items = []
          prediction['carrier_items'].each do |item|
            @carrier_items.push(BillOfLadingV1CarrierItem.new(item, page_id))
          end
          @consignee = BillOfLadingV1Consignee.new(prediction['consignee'], page_id)
          @date_of_issue = DateField.new(prediction['date_of_issue'], page_id)
          @departure_date = DateField.new(prediction['departure_date'], page_id)
          @notify_party = BillOfLadingV1NotifyParty.new(prediction['notify_party'], page_id)
          @place_of_delivery = StringField.new(prediction['place_of_delivery'], page_id)
          @port_of_discharge = StringField.new(prediction['port_of_discharge'], page_id)
          @port_of_loading = StringField.new(prediction['port_of_loading'], page_id)
          @shipper = BillOfLadingV1Shipper.new(prediction['shipper'], page_id)
        end

        # @return [String]
        def to_s
          shipper = @shipper.to_s
          consignee = @consignee.to_s
          notify_party = @notify_party.to_s
          carrier = @carrier.to_s
          carrier_items = carrier_items_to_s
          out_str = String.new
          out_str << "\n:Bill of Lading Number: #{@bill_of_lading_number}".rstrip
          out_str << "\n:Shipper:"
          out_str << shipper
          out_str << "\n:Consignee:"
          out_str << consignee
          out_str << "\n:Notify Party:"
          out_str << notify_party
          out_str << "\n:Carrier:"
          out_str << carrier
          out_str << "\n:Items:"
          out_str << carrier_items
          out_str << "\n:Port of Loading: #{@port_of_loading}".rstrip
          out_str << "\n:Port of Discharge: #{@port_of_discharge}".rstrip
          out_str << "\n:Place of Delivery: #{@place_of_delivery}".rstrip
          out_str << "\n:Date of issue: #{@date_of_issue}".rstrip
          out_str << "\n:Departure Date: #{@departure_date}".rstrip
          out_str[1..].to_s
        end

        private

        # @param char [String]
        # @return [String]
        def carrier_items_separator(char)
          out_str = String.new
          out_str << '  '
          out_str << "+#{char * 38}"
          out_str << "+#{char * 14}"
          out_str << "+#{char * 13}"
          out_str << "+#{char * 18}"
          out_str << "+#{char * 10}"
          out_str << "+#{char * 13}"
          out_str << '+'
          out_str
        end

        # @return [String]
        def carrier_items_to_s
          return '' if @carrier_items.empty?

          line_items = @carrier_items.map(&:to_table_line).join("\n#{carrier_items_separator('-')}\n  ")
          out_str = String.new
          out_str << "\n#{carrier_items_separator('-')}"
          out_str << "\n  |"
          out_str << ' Description                          |'
          out_str << ' Gross Weight |'
          out_str << ' Measurement |'
          out_str << ' Measurement Unit |'
          out_str << ' Quantity |'
          out_str << ' Weight Unit |'
          out_str << "\n#{carrier_items_separator('=')}"
          out_str << "\n  #{line_items}"
          out_str << "\n#{carrier_items_separator('-')}"
          out_str
        end
      end
    end
  end
end
