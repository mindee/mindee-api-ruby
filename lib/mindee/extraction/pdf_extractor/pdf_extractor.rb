# frozen_string_literal: true

module Mindee
  # Pdf Extraction Module.
  module PdfExtractor
    # Pdf Extraction class.
    class PdfExtractor
      # @param local_input [Mindee::Input::Source::LocalInputSource]
      def initialize(local_input)
        @filename = local_input.filename
        if local_input.pdf?
          @source_pdf = local_input.io_stream
        else
          pdf_image = attach_image_as_new_file(local_input.io_stream)
          io_buffer = StringIO.new
          pdf_image.save(io_buffer)

          @source_pdf = pdf_image
        end
      end

      # Retrieves the page count for the Pdf object.
      # @return [Integer]
      def page_count
        Origami::PDF.read(@source_pdf).pages.size
      end

      # Creates a new Pdf from pages and save it into a buffer.
      # @param page_indexes [Array<Integer>] List of page number to use for merging in the original Pdf.
      # @return [StreamIO] The buffer containing the new Pdf.
      def cut_pages(page_indexes)
        pdf = Origami::PDF.read(@source_pdf)
        new_pdf = Origami::PDF.new
        pdf.each_with_index do |page, index|
          new_pdf.append_page(page) if page_indexes.include?(index)
        end
        buffer = StringIO.new
        new_pdf.write(buffer)
        buffer
      end

      # Extract the sub-documents from the main pdf, based on the given list of page indexes.
      # @param page_indexes [Array<Array<Integer>>] List of page number to use for merging in the original Pdf.
      # @return [Array<ExtractedPdf>] The buffer containing the new Pdf.
      def extract_sub_documents(page_indexes)
        extracted_pdfs = []
        extension = File.extname(@filename)
        basename = File.basename(@filename)
        page_indexes.each do |page_index_list|
          raise "Empty indexes aren't allowed for extraction." if page_index_list.empty? || page_index_list.nil?

          page_index_list.each do |page_index|
            raise "Index #{page_index} is out of range." if (page_index > page_count) || page_index.negative?
          end
          formatted_max_index = "#{format('%03d', page_index_list[page_index_list.length - 1] + 1)}.#{extension}"
          field_filename = "#{basename}_#{format('%03d',
                                                 (page_index_list[0] + 1))}-#{formatted_max_index}#{extension}"
          extracted_pdf = ExtractedPdf.new(cut_pages(page_index_list), field_filename)
          extracted_pdfs << extracted_pdf
        end
        extracted_pdfs
      end

      # Extracts invoices as complete PDFs from the document.
      # @param page_indexes [Array<Array<Integer>, InvoiceSplitterV1PageGroup>]
      # @param strict [Boolean]
      # @return [Array<Mindee::PdfExtractor::ExtractedPdf>]
      def extract_invoices(page_indexes, strict: false)
        raise 'No indexes provided.' if page_indexes.empty?
        return extract_sub_documents(page_indexes) if page_indexes[0].is_a?(InvoiceSplitterV1PageGroup)
        return extract_sub_documents(page_indexes.map(&:page_indexes)) unless strict

        correct_page_indexes = process_page_indexes(page_indexes)
        extract_sub_documents(correct_page_indexes)
      end

      private

      def process_page_indexes(page_indexes)
        correct_page_indexes = []
        current_list = []
        previous_confidence = nil

        page_indexes.each_with_index do |page_index, i|
          confidence = page_index.confidence
          page_list = page_index.page_indexes

          if confidence_sufficient?(confidence, previous_confidence)
            current_list = page_list
          elsif low_confidence_with_more_pages?(confidence, i, page_indexes)
            handle_low_confidence(correct_page_indexes, current_list, page_list)
          else
            finalize_current_page(correct_page_indexes, current_list, page_list)
          end

          previous_confidence = confidence
        end

        correct_page_indexes
      end

      def confidence_sufficient?(confidence, previous_confidence)
        confidence >= 0.5 && !previous_confidence.nil?
      end

      def low_confidence_with_more_pages?(confidence, current_index, page_indexes)
        confidence < 0.5 && current_index < page_indexes.length - 1
      end

      def handle_low_confidence(correct_page_indexes, current_list, page_list)
        current_list += page_list
        correct_page_indexes << current_list
      end

      def finalize_current_page(correct_page_indexes, current_list, page_list)
        correct_page_indexes << current_list
        correct_page_indexes << page_list
      end

      attr_reader :source_pdf, :filename
    end
  end
end
