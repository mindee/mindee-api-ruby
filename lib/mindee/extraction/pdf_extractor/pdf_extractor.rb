# frozen_string_literal: true

module Mindee
  # Pdf Extraction Module.
  module Extraction
    # Pdf Extraction class.
    module PdfExtractor
      # Pdf extraction class.
      class PdfExtractor
        # @param local_input [Mindee::Input::Source::LocalInputSource]
        def initialize(local_input)
          @filename = local_input.filename
          if local_input.pdf?
            @source_pdf = local_input.io_stream
          else
            pdf_image = Extraction::ImageExtractor.attach_image_as_new_file(local_input.io_stream)
            io_buffer = StringIO.new
            pdf_image.save(io_buffer)

            @source_pdf = io_buffer
          end
        end

        # Retrieves the page count for the Pdf object.
        # @return [Integer]
        def page_count
          Mindee::PDF::PdfProcessor.open_pdf(@source_pdf).pages.size
        end

        # Creates a new Pdf from pages and save it into a buffer.
        # @param page_indexes [Array<Integer>] List of page number to use for merging in the original Pdf.
        # @return [StreamIO] The buffer containing the new Pdf.
        def cut_pages(page_indexes)
          options = {
            page_indexes: page_indexes,
          }

          Mindee::PDF::PdfProcessor.parse(@source_pdf, options)
        end

        # Extract the sub-documents from the main pdf, based on the given list of page indexes.
        # @param page_indexes [Array<Array<Integer>>] List of page number to use for merging in the original Pdf.
        # @return [Array<Mindee::Extraction::PdfExtractor::ExtractedPdf>] The buffer containing the new Pdf.
        def extract_sub_documents(page_indexes)
          extracted_pdfs = []
          extension = File.extname(@filename)
          basename = File.basename(@filename, extension)
          page_indexes.each do |page_index_list|
            if page_index_list.empty? || page_index_list.nil?
              raise "Empty indexes aren't allowed for extraction #{page_index_list}"
            end

            page_index_list.each do |page_index|
              raise "Index #{page_index} is out of range." if (page_index > page_count) || page_index.negative?
            end
            formatted_max_index = format('%03d', page_index_list[page_index_list.length - 1] + 1).to_s
            field_filename = "#{basename}_#{format('%03d',
                                                   (page_index_list[0] + 1))}-#{formatted_max_index}#{extension}"
            extracted_pdf = Mindee::Extraction::PdfExtractor::ExtractedPdf.new(cut_pages(page_index_list),
                                                                               field_filename)
            extracted_pdfs << extracted_pdf
          end
          extracted_pdfs
        end

        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/PerceivedComplexity

        # Extracts invoices as complete PDFs from the document.
        # @param page_indexes [Array<Array<Integer>, InvoiceSplitterV1PageGroup>]
        # @param strict [Boolean]
        # @return [Array<Mindee::Extraction::PdfExtractor::ExtractedPdf>]
        def extract_invoices(page_indexes, strict: false)
          raise 'No indexes provided.' if page_indexes.empty?
          unless page_indexes[0].is_a?(Mindee::Product::InvoiceSplitter::InvoiceSplitterV1PageGroup)
            return extract_sub_documents(page_indexes)
          end
          return extract_sub_documents(page_indexes.map(&:page_indexes)) unless strict

          correct_page_indexes = []
          current_list = []
          previous_confidence = nil
          page_indexes.each_with_index do |page_index, i|
            confidence = page_index.confidence
            page_list = page_index.page_indexes

            if confidence >= 0.5 && previous_confidence.nil?
              current_list = page_list
            elsif confidence >= 0.5 && i < page_indexes.length - 1
              correct_page_indexes << current_list
              current_list = page_list
            elsif confidence < 0.5 && i == page_indexes.length - 1
              current_list.concat page_list
              correct_page_indexes << current_list
            else
              correct_page_indexes << current_list
              correct_page_indexes << page_list
            end
            previous_confidence = confidence
          end
          extract_sub_documents(correct_page_indexes)
        end

        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/PerceivedComplexity

        private

        attr_reader :source_pdf, :filename
      end
    end
  end
end
