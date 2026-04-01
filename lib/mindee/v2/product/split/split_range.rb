# frozen_string_literal: true

module Mindee
  module V2
    module Product
      module Split
        # Split inference result.
        class SplitRange
          # @return [Array<Integer>] 0-based page indexes, where the first integer indicates the start page and the
          #     second integer indicates the end page.
          attr_reader :page_range
          # @return [String] The document type, as identified on given classification values.
          attr_reader :document_type

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @page_range = server_response['page_range']
            @document_type = server_response['document_type']
          end

          # String representation.
          # @return [String]
          def to_s
            "* :Page Range: #{@page_range}\n  :Document Type: #{@document_type}"
          end

          # Apply the split range inference to a file and return a single extracted PDF.
          #
          # @param input_source [Mindee::Input::Source::LocalInputSource] Local file to extract from
          # @return [Image::ExtractedImage]
          def extract_from_file(input_source)
            FileOperation::Split.extract_single_split(input_source, @page_range)
          end
        end
      end
    end
  end
end
