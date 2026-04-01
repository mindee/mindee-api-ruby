# frozen_string_literal: true

require_relative '../../parsing/base_response'
require_relative 'params/split_parameters'
require_relative 'split_inference'

module Mindee
  module V2
    module Product
      module Split
        # HTTP response wrapper that embeds a V2 Inference.
        class SplitResponse < Mindee::V2::Parsing::BaseResponse
          # @return [SplitInference] Parsed inference payload.
          attr_reader :inference

          # @param server_response [Hash] Hash parsed from the API JSON response.
          def initialize(server_response)
            super

            @inference = SplitInference.new(server_response['inference'])
          end

          # String representation.
          # @return [String]
          def to_s
            @inference.to_s
          end

          # Extracts the crops from the input source.
          # @param input_source [Mindee::Input::Source::LocalInputSource] Path to the file or a File object.
          # @return [FileOperation::SplitFiles]
          def extract_from_file(input_source)
            crop_files = @inference.result.splits.map do |crop|
              crop.extract_from_file(input_source)
            end
            FileOperation::SplitFiles.new(crop_files)
          end
        end
      end
    end
  end
end
