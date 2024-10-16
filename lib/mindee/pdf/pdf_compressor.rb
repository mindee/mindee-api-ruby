# frozen_string_literal: true

module Mindee
  module PDF
    # Image compressor module to handle PDF compression.
    module PDFCompressor
      def self.compress_pdf(
        pdf_data,
        quality: 85,
        force_source_text: false,
        disable_source_text: true
      )
        return pdf_data if !force_source_text && PDFTools.source_text?(pdf_data)

        pdf_data.rewind
        pdf = Origami::PDF.read(pdf_data)
        output_pdf = Origami::PDF.new
        pdf.pages.each.with_index do |_, i|
          process_pdf_page(Mindee::PDF::PdfProcessor.get_page(pdf, i), output_pdf, i, quality, disable_source_text)
        end

        output_stream = StringIO.new
        output_pdf.save(output_stream)
        output_stream
      end

      def self.process_pdf_page(page_stream, output_doc, page_index, image_quality, _disable_source_text)
        new_page = Origami::Page.new

        compressed_image = MiniMagick::Image.read(page_stream.read)
        compressed_image.format('jpg')
        compressed_image.quality image_quality.to_s
        image_io = Mindee::Image::ImageUtils.image_to_stringio(compressed_image)
        compressed_xobject = Origami::Graphics::ImageXObject.from_image_file(image_io, 'jpg')
        compressed_xobject.dictionary[:BitsPerComponent] = 8
        compressed_xobject.dictionary[:Filter] = :DCTDecode
        compressed_xobject.dictionary[:Width] = compressed_image[:width]
        compressed_xobject.dictionary[:Height] = compressed_image[:height]
        compressed_xobject.dictionary[:ColorSpace] = :DeviceRGB
        xobject_name = "X#{page_index + 1}"
        content = "q\n#{compressed_image[:width]} 0 0 #{compressed_image[:height]} 0 0 cm\n/#{xobject_name} Do\nQ\n"
        content_stream = Origami::Stream.new(content)
        new_page.Contents = content_stream

        new_page.add_xobject(compressed_xobject, xobject_name)
        output_doc.append_page new_page
      end

      def self.process_image_xobject(image_data, image_quality, width, height)
        compressed_data = Image::ImageCompressor.compress_image(
          image_data,
          quality: image_quality,
          max_width: width,
          max_height: height
        )

        new_image = Origami::Graphics::ImageXObject.new
        new_image.data = compressed_data
        new_image.Width = width
        new_image.Height = height
        new_image.ColorSpace = :DeviceRGB
        new_image.BitsPerComponent = 8

        new_image
      end
    end
  end
end
