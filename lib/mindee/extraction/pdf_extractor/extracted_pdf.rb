# frozen_string_literal: true

module Mindee
  # Pdf Extraction Module.
  module Extraction
    module PdfExtractor
      # An extracted sub-Pdf.
      class ExtractedPdf
        # Byte contents of the pdf
        # @return [StreamIO]
        attr_reader :pdf_bytes

        # Name of the file.
        # @return [String]
        attr_reader :filename

        # @param pdf_bytes [StreamIO]
        # @param filename [String]
        def initialize(pdf_bytes, filename)
          @pdf_bytes = pdf_bytes
          @filename = filename
        end

        # Retrieves the page count for a given pdf.
        # @return [Integer]
        def page_count
          current_pdf = Mindee::PDF::PdfProcessor.open_pdf(pdf_bytes)
          current_pdf.pages.size
        rescue TypeError
          raise Errors::MindeePDFError, 'Could not retrieve page count from Extracted PDF object.'
        end

        # Writes the contents of the current PDF object to a file.
        # @param output_path [String] Path to write to.
        def write_to_file(output_path)
          raise Errors::MindeePDFError, 'Provided path is not a file' if File.directory?(destination)
          raise Errors::MindeePDFError, 'Invalid save path provided' unless File.exist?(File.expand_path('..',
                                                                                                         output_path))

          if File.extname(output_path).downcase == '.pdf'
            base_path = File.expand_path('..', output_path)
            output_path = File.expand_path("#{File.basename(output_path)}.pdf", base_path)
          end

          File.write(output_path, @pdf_bytes)
        end

        # Returns the current PDF object as a usable BytesInputSource.
        # @return [Mindee::Input::Source::BytesInputSource]
        def as_input_source
          Mindee::Input::Source::BytesInputSource.new(@pdf_bytes.read, @filename)
        end
      end
    end
  end
end
