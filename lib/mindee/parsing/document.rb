# frozen_string_literal: true

require_relative 'inference'

module Mindee
  # Stores all response attributes.
  class Document
    # @return [Mindee::Inference]
    attr_reader :inference
    # @return [String]
    attr_reader :name
    # @return [String]
    attr_reader :id

    # @param prediction_class [Class<Mindee::Prediction::Prediction>]
    # @param http_response [Hash]
    def initialize(prediction_class, http_response)
      @id = http_response['id']
      @name = http_response['name']
      @inference = Mindee::Inference.new(prediction_class, http_response['inference'])
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
