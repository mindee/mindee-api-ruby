# frozen_string_literal: true

require_relative 'split_range'

module Mindee
  module V2
    module Product
      module Split
        # Result of a split utility inference.
        class SplitResult
          # @return [Array<SplitRange>] List of results of splitped document regions.
          attr_reader :splits

          # @param server_response [Hash] Hash representation of the JSON returned by the service.
          def initialize(server_response)
            @splits = if server_response.key?('splits')
                        server_response['splits'].map do |split|
                          SplitRange.new(split)
                        end
                      end
          end

          # Splits the input PDF.
          # @param input_source [Mindee::Input::Source::LocalInputSource] Path to the file or a File object.
          # @return [PDF::ExtractedPDFs]
          def extract_from_input_source(input_source)
            splits = @inference.result.splits.map(&:page_range)
            FileOperation::Split.extract_splits(input_source, splits)
          end

          # String representation.
          # @return [String]
          def to_s
            splits_str = @splits.join("\n")

            "Splits\n======\n#{splits_str}"
          end
        end
      end
    end
  end
end
