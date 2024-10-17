# frozen_string_literal: true

require 'pdf-reader'
PDFReader = PDF

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
        pages = []
        pdf.pages.each.with_index do |page, i|
          page = process_pdf_page(Mindee::PDF::PdfProcessor.get_page(pdf, i), i, quality, page[:MediaBox])
          pages.append(page)
        end

        output_pdf = Origami::PDF.new
        # The manual insertion of the xobject parameters into the PDF seems to put the last created page in the first
        # position. This fixes it.
        pages.push(pages.shift) unless pages.count < 2

        inject_text(pdf_data, pages) unless disable_source_text
        pages.each do |page|
          output_pdf.append_page(page)
        end

        pages.each

        output_stream = StringIO.new
        output_pdf.save(output_stream)
        output_stream
      end

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

      def self.process_pdf_page(page_stream, page_index, image_quality, media_box)
        new_page = Origami::Page.new
        compressed_image = compress_image(page_stream, image_quality)
        width, height = calculate_dimensions(compressed_image, media_box)

        compressed_xobject = create_xobject(compressed_image)
        set_xobject_properties(compressed_xobject, compressed_image)

        xobject_name = "X#{page_index + 1}"
        add_content_to_page(new_page, xobject_name, width, height)
        new_page.add_xobject(compressed_xobject, xobject_name)

        set_page_dimensions(new_page, width, height)
        new_page
      end

      def self.compress_image(page_stream, image_quality)
        compressed_image = MiniMagick::Image.read(page_stream.read)
        compressed_image.format('jpg')
        compressed_image.quality image_quality.to_s
        compressed_image
      end

      def self.calculate_dimensions(image, media_box)
        if media_box && !media_box.empty?
          [
            media_box[2]&.to_i || image[:width],
            media_box[3]&.to_i || image[:height],
          ]
        else
          [image[:width], image[:height]]
        end
      end

      def self.create_xobject(image)
        image_io = Mindee::Image::ImageUtils.image_to_stringio(image)
        Origami::Graphics::ImageXObject.from_image_file(image_io, 'jpg')
      end

      def self.set_xobject_properties(xobject, image)
        xobject.dictionary[:BitsPerComponent] = 8
        xobject.dictionary[:Filter] = determine_filter(image)
        xobject.dictionary[:Width] = image[:width]
        xobject.dictionary[:Height] = image[:height]
        xobject.dictionary[:ColorSpace] = determine_colorspace(image)
      end

      def self.determine_filter(image)
        filter = image.data['properties']['filter']
        case filter
        when %r{Zip}i then :FlateDecode
        when %r{LZW}i then :LZWDecode
        else :DCTDecode
        end
      end

      def self.determine_colorspace(image)
        colorspace = image.data['colorspace']
        case colorspace
        when 'CMYK' then :DeviceCMYK
        when 'Gray', 'PseudoClass Gray' then :DeviceGray
        else :DeviceRGB
        end
      end

      def self.add_content_to_page(page, xobject_name, width, height)
        content = "q\n#{width} 0 0 #{height} 0 0 cm\n/#{xobject_name} Do\nQ\n"
        content_stream = Origami::Stream.new(content)
        page.Contents = content_stream
      end

      def self.set_page_dimensions(page, width, height)
        page[:MediaBox] = [0, 0, width, height]
        page[:CropBox] = [0, 0, width, height]
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
