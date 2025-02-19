# frozen_string_literal: true

require 'pdf-reader'
# Shorthand for pdf-reader's PDF namespace, to avoid mixups with the local Origami fork.
PDFReader = PDF

module Mindee
  module PDF
    # Image compressor module to handle PDF compression.
    module PDFCompressor
      # Compresses each page of a provided PDF stream. Skips if force_source_text isn't set and source text is detected.
      # @param pdf_data [StringIO] StringIO handle of the file.
      # @param quality [Integer] Compression quality (70-100 for most JPG images in the test dataset).
      # @param force_source_text_compression [bool] If true, attempts to re-write detected text.
      # @param disable_source_text [bool] If true, doesn't re-apply source text to the original PDF.
      def self.compress_pdf(pdf_data, quality: 85, force_source_text_compression: false, disable_source_text: true)
        if PDFTools.source_text?(pdf_data)
          if force_source_text_compression
            if disable_source_text
              logger.warn('Re-writing PDF source-text is an EXPERIMENTAL feature.')
            else
              logger.warn('Source-file contains text, but disable_source_text flag is ignored. ' \
                          'Resulting file will not contain any embedded text.')
            end
          else
            logger.warn('Source-text detected in input PDF. Aborting operation.')
            return pdf_data
          end
        end

        pdf_data.rewind
        pdf = Origami::PDF.read(pdf_data)
        pages = process_pdf_pages(pdf, quality)

        output_pdf = create_output_pdf(pages, disable_source_text, pdf_data)

        output_stream = StringIO.new
        output_pdf.save(output_stream)
        output_stream
      end

      # Processes all pages in the PDF.
      # @param pdf [Origami::PDF] The Origami PDF object to process.
      # @param quality [Integer] Compression quality.
      # @return [Array<Origami::Page>] Processed pages.
      def self.process_pdf_pages(pdf, quality)
        pdf.pages.map.with_index do |page, index|
          retrieved_page = Mindee::PDF::PDFProcessor.get_page(pdf, index)
          process_pdf_page(retrieved_page, index, quality, page[:MediaBox])
        end
      end

      # Creates the output PDF with processed pages.
      # @param pages [Array<Origami::Page>] Processed pages.
      # @param disable_source_text [bool] Whether to disable source text.
      # @param pdf_data [StringIO] Original PDF data.
      # @return [Origami::PDF] Output PDF object.
      def self.create_output_pdf(pages, disable_source_text, pdf_data)
        output_pdf = Origami::PDF.new
        pages.rotate!(1) if pages.count >= 2

        inject_text(pdf_data, pages) unless disable_source_text

        pages.each { |page| output_pdf.append_page(page) }

        output_pdf
      end

      # Extracts text from a source text PDF, and injects it into a newly-created one.
      # @param pdf_data [StringIO] Stream representation of the PDF.
      # @param pages [Array<Origami::Page>] Array of pages containing the rasterized version of the initial pages.
      def self.inject_text(pdf_data, pages)
        reader = PDFReader::Reader.new(pdf_data)

        reader.pages.each_with_index do |original_page, index|
          break if index >= pages.length

          receiver = PDFReader::Reader::PageTextReceiver.new
          original_page.walk(receiver)

          receiver.runs.each do |text_run|
            x = text_run.origin.x
            y = text_run.origin.y
            text = text_run.text
            font_size = text_run.font_size

            content_stream = Origami::Stream.new
            content_stream.dictionary[:Filter] = :FlateDecode
            content_stream.data = "BT\n/F1 #{font_size} Tf\n#{x} #{y} Td\n(#{text}) Tj\nET\n"

            pages[index].Contents.data += content_stream.data
          end
        end
      end

      # Takes in a page stream, rasterizes it into a JPEG image, and applies the result onto a new Origami PDF page.
      # @param page_stream [StringIO] Stream representation of a single page from the initial PDF.
      # @param page_index [Integer] Index of the current page. Technically not needed, but left for debugging purposes.
      # @param image_quality [Integer] Quality to apply to the rasterized page.
      # @param media_box [Array<Integer>, nil] Extracted media box from the page. Can be nil.
      # @return [Origami::Page]
      def self.process_pdf_page(page_stream, page_index, image_quality, media_box)
        new_page = Origami::Page.new
        compressed_image = Mindee::Image::ImageUtils.pdf_to_magick_image(page_stream, image_quality)
        width, height = Mindee::Image::ImageUtils.calculate_dimensions_from_media_box(compressed_image, media_box)

        compressed_xobject = PDF::PDFTools.create_xobject(compressed_image)
        PDF::PDFTools.set_xobject_properties(compressed_xobject, compressed_image)

        xobject_name = "X#{page_index + 1}"
        PDF::PDFTools.add_content_to_page(new_page, xobject_name, width, height)
        new_page.add_xobject(compressed_xobject, xobject_name)

        PDF::PDFTools.set_page_dimensions(new_page, width, height)
        new_page
      end
    end
  end
end
