# frozen_string_literal: true

require 'origami'

module Mindee
  module PDF
    # Collection of miscellaneous PDF operations,as well as some monkey-patching for Origami.
    module PDFTools
      # Converts the current PDF document into a binary-encoded StringIO stream.
      #
      # @param [Hash] params Optional settings to override default processing flags.
      #   - :delinearize [bool] (default: true) Whether to convert a linearized PDF to its full form.
      #   - :recompile [bool] (default: true) Whether to recompile the PDF after processing.
      #   - :decrypt [bool] (default: false) Whether to attempt to decrypt the PDF.
      #   - Other keys such as :intent, :rebuild_xrefs, :noindent, and :obfuscate may be modified automatically.
      #
      # @return [StringIO] A binary-encoded stream representing the processed PDF.
      def to_io_stream(params = {})
        options = {
          delinearize: true,
          recompile: true,
          decrypt: false,
          noindent: nil,
        }
        options.update(params)

        if frozen? # incompatible flags with frozen doc (signed)
          options[:recompile] = nil
          options[:rebuild_xrefs] = nil
          options[:noindent] = nil
          options[:obfuscate] = false
        end
        load_all_objects unless @loaded

        intents_as_pdfa1 if options[:intent].to_s =~ %r{pdf[/-]?A1?/i}
        delinearize! if options[:delinearize] && linearized?
        compile(options) if options[:recompile]

        io_stream = StringIO.new(output(options))
        io_stream.set_encoding Encoding::BINARY
        io_stream
      end

      # Checks a PDFs stream content for text operators
      # See https://opensource.adobe.com/dc-acrobat-sdk-docs/pdfstandards/PDF32000_2008.pdf page 243-251.
      # @param [StringIO] stream Stream object from a PDFs page.
      # @return [bool] True if a text operator is found in the stream.
      def self.stream_has_text?(stream)
        data = stream.data
        return false if data.nil? || data.empty?

        text_operators = ['Tc', 'Tw', 'Th', 'TL', 'Tf', 'Tk', 'Tr', 'Tm', 'T*', 'Tj', 'TJ', "'", '"']
        text_operators.any? { |op| data.include?(op) }
      end

      # Checks whether the file has source_text. Sends false if the file isn't a PDF.
      # @param [StringIO] pdf_data Abinary-encoded stream representing the PDF file.
      # @return [bool] True if the pdf has source text, false otherwise.
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

      # Creates an image XObject from the provided image.
      #
      # Converts the given image to a binary stream using Mindee's image utilities, then creates
      # an Origami::Graphics::ImageXObject with a JPEG filter.
      #
      # @param [MiniMagick::Image] image An image object with the necessary data and structure.
      # @return [Origami::Graphics::ImageXObject] The created image XObject.
      def self.create_xobject(image)
        image_io = Mindee::Image::ImageUtils.image_to_stringio(image)
        Origami::Graphics::ImageXObject.from_image_file(image_io, 'jpg')
      end

      # Sets properties on the provided image XObject based on image metadata.
      #
      # @param [Origami::Graphics::ImageXObject] xobject The image XObject to update.
      # @param [Hash] image A hash containing image metadata (such as width, height, properties, etc.).
      def self.set_xobject_properties(xobject, image)
        xobject.dictionary[:BitsPerComponent] = 8
        xobject.dictionary[:Filter] = determine_filter(image)
        xobject.dictionary[:Width] = image[:width]
        xobject.dictionary[:Height] = image[:height]
        xobject.dictionary[:ColorSpace] = determine_colorspace(image)
      end

      # Determines the appropriate filter for an image based on its properties.
      #
      # @param [Hash] image The image data hash containing properties.
      # @return [Symbol] One of :FlateDecode, :LZWDecode or :DCTDecode.
      def self.determine_filter(image)
        filter = image.data['properties']['filter']
        case filter
        when %r{Zip}i then :FlateDecode
        when %r{LZW}i then :LZWDecode
        else :DCTDecode
        end
      end

      # Determines the colorspace for an image based on its metadata.
      #
      # @param [Hash] image The image data hash.
      # @return [Symbol] One of :DeviceCMYK, :DeviceGray or :DeviceRGB.
      def self.determine_colorspace(image)
        colorspace = image.data['colorspace']
        case colorspace
        when 'CMYK' then :DeviceCMYK
        when 'Gray', 'PseudoClass Gray' then :DeviceGray
        else :DeviceRGB
        end
      end

      # Adds a content stream to the specified PDF page to display an image XObject.
      #
      # @param [Origami::Page] page The PDF page to which content will be added.
      # @param [String] xobject_name The name identifying the XObject.
      # @param [Integer] width The width for the transformation matrix.
      # @param [Integer] height The height for the transformation matrix.
      def self.add_content_to_page(page, xobject_name, width, height)
        content = "q\n#{width} 0 0 #{height} 0 0 cm\n/#{xobject_name} Do\nQ\n"
        content_stream = Origami::Stream.new(content)
        page.Contents = content_stream
      end

      # Sets the dimensions for the specified PDF page.
      #
      # @param [Origami::Page] page The PDF page whose dimensions are being set.
      # @param [Numeric] width The target width of the page.
      # @param [Numeric] height The target height of the page.
      def self.set_page_dimensions(page, width, height)
        page[:MediaBox] = [0, 0, width, height]
        page[:CropBox] = [0, 0, width, height]
      end

      # Processes an image into an image XObject for PDF embedding.
      #
      # @param [MiniMagick::Image, StringIO] image_data The raw image data.
      # @param [Integer] image_quality The quality setting for image compression.
      # @param [Numeric] width The desired width of the output image.
      # @param [Numeric] height The desired height of the output image.
      # @return [Origami::Graphics::ImageXObject] The resulting image XObject.
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
