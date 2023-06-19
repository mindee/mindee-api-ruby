# frozen_string_literal: true

require_relative 'inference'

module Mindee
  # Stores all response attributes.
  class Document
    # @return [Mindee::Inference]
    attr_reader :inference
    # @return [String] Filename sent to the API
    attr_reader :name
    # @return [String] Mindee ID of the document
    attr_reader :id
    # @return [Mindee::Ocr::Ocr, nil]
    attr_reader :ocr

    # @param http_response [Hash]
    # @return [Mindee::Ocr::Ocr]
    def self.load_ocr(http_response)
      ocr_prediction = http_response.fetch('ocr', nil)
      return nil if ocr_prediction.nil? || ocr_prediction.fetch('mvision-v1', nil).nil?

      Ocr(ocr_prediction)
    end

    # @param prediction_class [Class<Mindee::Prediction::Prediction>]
    # @param http_response [Hash]
    def initialize(prediction_class, http_response)
      @id = http_response['id']
      @name = http_response['name']
      @inference = Mindee::Inference.new(prediction_class, http_response['inference'])
      @ocr = self.class.load_ocr(http_response)
    end

    def to_s
      out_str = String.new
      out_str << "########\nDocument\n########"
      out_str << "\n:Mindee ID: #{@id}"
      out_str << "\n:Filename: #{@name}"
      out_str << "\n\n#{@inference}"
    end
  end
end
