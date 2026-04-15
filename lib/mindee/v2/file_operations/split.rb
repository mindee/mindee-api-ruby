# frozen_string_literal: true

module Mindee
  module V2
    module FileOperation
      # Split operations.
      module Split
        # Extracts a single split as a complete PDF from the document.
        #
        # @param input_source [LocalInputSource] Input source to split.
        # @param split [Array<Integer>] List of pages to keep.
        # @return [ExtractedPDF] Extracted PDF
        def self.extract_single_split(input_source, split)
          extract_splits(input_source, [split]).first
        end

        # Extracts splits as complete PDFs from the document.
        #
        # @param input_source [LocalInputSource] Input source to split.
        # @param splits [Array<Array<Integer>>] List of sub-lists of pages to keep.
        # @return [SplitFiles] A list of extracted invoices.
        # @raise [MindeeError] if no indexes are provided.
        def self.extract_splits(input_source, splits)
          raise Mindee::Error::MindeeError, 'No indexes provided.' if splits.nil? || splits.empty?

          pdf_extractor = Mindee::PDF::PDFExtractor.new(input_source)

          page_groups = splits.map do |split|
            (split[0]..split[1]).to_a
          end

          SplitFiles.new(pdf_extractor.extract_sub_documents(page_groups))
        end
      end
    end
  end
end
