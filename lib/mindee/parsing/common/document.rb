# frozen_string_literal: true

require_relative 'inference'
require_relative 'extras'

module Mindee
  module Parsing
    module Common
      # Stores all response attributes.
      class Document
        # @return [Mindee::Inference]
        attr_reader :inference
        # @return [String] Filename sent to the API
        attr_reader :name
        # @return [String] Mindee ID of the document
        attr_reader :id
        # @return [Mindee::Parsing::Common::Extras::Extras] Potential Extras fields sent back along the prediction.
        attr_reader :extras
        # @return [Mindee::Parsing::Common::Ocr::Ocr, nil] OCR text results (limited availability)
        attr_reader :ocr
        # @return [Integer] Amount of pages of the document
        attr_reader :n_pages

        # @param http_response [Hash]
        # @return [Mindee::Parsing::Common::Ocr::Ocr]
        def self.load_ocr(http_response)
          ocr_prediction = http_response.fetch('ocr', nil)
          return nil if ocr_prediction.nil? || ocr_prediction.fetch('mvision-v1', nil).nil?

          Ocr::Ocr.new(ocr_prediction)
        end

        def self.load_extras(http_response)
          extras_prediction = http_response['inference'].fetch('extras', nil)
          return nil if extras_prediction.nil? || extras_prediction.fetch('mvision-v1', nil).nil?

          Extras::Extras::Extras.new(extras_prediction)
        end

        # @param product_class [Mindee::Inference]
        # @param http_response [Hash]
        def initialize(product_class, http_response)
          @id = http_response['id']
          @name = http_response['name']
          @inference = product_class.new(http_response['inference'])
          @ocr = self.class.load_ocr(http_response)
          @extras = self.class.load_extras(http_response)
          inject_full_text_ocr(http_response)
          @n_pages = http_response['n_pages']
        end

        # @return [String]
        def to_s
          out_str = String.new
          out_str << "########\nDocument\n########"
          out_str << "\n:Mindee ID: #{@id}"
          out_str << "\n:Filename: #{@name}"
          out_str << "\n\n#{@inference}"
        end

        private

        def inject_full_text_ocr(raw_prediction)
          return unless raw_prediction.dig('inference', 'pages', 0, 'extras', 'full_text_ocr')


          full_text_ocr = String.new
          raw_prediction.dig('inference', 'pages').each do |page|
            full_text_ocr << (page['extras']['full_text_ocr']['content'])
          end
          artificial_text_obj = { 'content' => full_text_ocr }
          if @extras.nil? || @extras.empty?
            @extras = Extras::Extras.new({ 'full_text_ocr' => artificial_text_obj })
          else
            @extras.add_artificial_extra({ 'full_text_ocr' => artificial_text_obj })
          end
        end
      end
    end
  end
end
