# frozen_string_literal: true

module Mindee
  # PDF Extraction Module.
  module PDF
    # An extracted sub-Pdf.
    class ExtractedPDF
      # Byte contents of the pdf
      # @return [StringIO]
      attr_reader :pdf_bytes

      # Name of the file.
      # @return [String]
      attr_reader :filename

      # @param pdf_bytes [StringIO]
      # @param filename [String]
      def initialize(pdf_bytes, filename)
        @pdf_bytes = pdf_bytes
        @filename = filename
      end

      # Retrieves the page count for a given pdf.
      # @return [Integer]
      def page_count
        current_pdf = Mindee::PDF::PDFProcessor.open_pdf(pdf_bytes)
        current_pdf.pages.size
      rescue TypeError, Origami::InvalidPDFError
        raise Error::MindeePDFError, 'Could not retrieve page count from Extracted PDF object.'
      end

      # Writes the contents of the current PDF object to a file.
      # @param output_path [String] Path to write to.
      # @param override [bool] Whether to override the destination file.
      def write_to_file(output_path, override: false)
        raise Error::MindeePDFError, 'Provided path is not a file' if File.directory?(output_path)
        raise Error::MindeePDFError, 'Invalid save path provided' unless File.exist?(
          File.expand_path('..', output_path)
        ) && !override

        if File.extname(output_path).downcase == 'pdf'
          base_path = File.expand_path('..', output_path)
          output_path = File.expand_path("#{File.basename(output_path)}.pdf", base_path)
        end

        @pdf_bytes.rewind if @pdf_bytes.respond_to?(:rewind)
        File.binwrite(output_path, @pdf_bytes.read.to_s)
        @pdf_bytes.rewind if @pdf_bytes.respond_to?(:rewind)
      end

      # Returns the current PDF object as a usable BytesInputSource.
      # @return [Mindee::Input::Source::BytesInputSource]
      def as_input_source
        raise Error::MindeePDFError, 'Bytes object is nil.' if @pdf_bytes.nil?

        @pdf_bytes.rewind if @pdf_bytes.respond_to?(:rewind)
        data = @pdf_bytes.read || ''
        @pdf_bytes.rewind if @pdf_bytes.respond_to?(:rewind)

        Mindee::Input::Source::BytesInputSource.new(data, @filename)
      end
    end
  end
end
