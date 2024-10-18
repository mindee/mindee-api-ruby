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
