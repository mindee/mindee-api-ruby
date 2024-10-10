# frozen_string_literal: true

module Mindee
  module PDF
    # Monkey-patching for Origami
    module PDFTools
      # @return [StringIO]
      def to_io_stream(params = {})
        options = {
          delinearize: true,
          recompile: true,
          decrypt: false,
        }
        options.update(params)

        if frozen? # incompatible flags with frozen doc (signed)
          options[:recompile] = nil
          options[:rebuild_xrefs] = nil
          options[:noindent] = nil
          options[:obfuscate] = false
        end
        load_all_objects unless @loaded

        intents_as_pdfa1 if options[:intent] =~ %r{pdf[/-]?A1?/i}
        delinearize! if options[:delinearize] && linearized?
        compile(options) if options[:recompile]

        io_stream = StringIO.new(output(options))
        io_stream.set_encoding Encoding::BINARY
        io_stream
      end

      # Checks a PDFs stream content for text operators
      # See https://opensource.adobe.com/dc-acrobat-sdk-docs/pdfstandards/PDF32000_2008.pdf page 243-251.
      # @param [StringIO] stream Stream object from a PDFs page.
      # @return [Boolean] True if a text operator is found in the stream.
      def self.stream_has_text?(stream)
        data = stream.data
        return false if data.nil? || data.empty?

        text_operators = ['Tc', 'Tw', 'Th', 'TL', 'Tf', 'Tfs', 'Tk', 'Tr', 'Tm', 'T*', 'Tj', 'TJ', "'", '"']
        text_operators.any? { |op| data.include?(op) }
      end

      # Checks whether the file has source_text. Sends false if the file isn't a PDF.
      # @param [StringIO] pdf_data
      # @return [Boolean] True if the pdf has source text, false otherwise.
      def self.source_text?(pdf_data)
        begin
          pdf_data.rewind
          pdf = Origami::PDF.read(pdf_data)

          pdf.each_page do |page|
            next unless page[:Contents]

            contents = page[:Contents].solve
            contents = [contents] unless contents.is_a?(Origami::Array)

            contents.each do |stream_ref|
              stream = stream_ref.solve
              return true if stream_has_text?(stream)
            end
          end

          false
        end

        false
      rescue Origami::InvalidPDFError
        false
      end
    end
  end
end
