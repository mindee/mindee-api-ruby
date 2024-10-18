# frozen_string_literal: true

module Mindee
  # Image processing module.
  module Image
    # Miscellaneous image operations.
    module ImageUtils
      # Resizes a provided MiniMagick Image with the given width & height, if present.
      # @param image [MiniMagick::Image] MiniMagick image handle.
      # @param width [Integer] Width to comply with.
      # @param height [Integer] Height to comply with.
      def self.resize_image(image, width, height)
        if width && height
          image.resize "#{width}x#{height}"
        elsif width
          image.resize width.to_s
        elsif height
          image.resize "x#{height}"
        end
      end

      # Compresses the quality of the provided MiniMagick image.
      # @param image [MiniMagick::Image] MiniMagick image handle.
      # @param quality [Integer] Quality to apply to the image. This is independent from a JPG's base quality.
      def self.compress_image_quality(image, quality)
        image.quality quality.to_s
      end

      # Mostly here so that IDEs don't get confused on the type (@type annotation fails sometimes.)
      # @param [MiniMagick::Image, StringIO, File, Tempfile] image The input image
      # @return [MiniMagick::Image]
      def self.to_image(image)
        if image.respond_to?(:read) && image.respond_to?(:rewind)
          image.rewind
          MiniMagick::Image.read(image)
        elsif image.is_a?(MiniMagick::Image)
          image
        else
          raise "Expected an I/O object or a MiniMagick::Image. '#{image.class}' given instead."
        end
      end

      # Converts a StringIO containing an image into a MiniMagick image.
      # @param image [MiniMagick::Image] the input image.
      # @param format [String] Format parameter, left open for the future, but should be JPEG for current use-cases.
      # @return [StringIO]
      def self.image_to_stringio(image, format = 'JPEG')
        image.format format
        blob = image.to_blob
        stringio = StringIO.new(blob)
        stringio.rewind

        stringio
      end

      # Computes the new dimensions for a given SKBitmap, and returns a scaled down version of it relative to the
      # provided bounds.
      # @param [MiniMagick::Image] original Input MiniMagick image.
      # @param max_width [Integer] Maximum width. If not specified, the horizontal ratio will remain the same.
      # @param max_height [Integer] Maximum height. If not specified, the vertical ratio will remain the same.
      def self.calculate_new_dimensions(original, max_width: nil, max_height: nil)
        raise 'Provided image could not be processed for resizing.' if original.nil?

        return [original.width, original.height] if max_width.nil? && max_height.nil?

        width_ratio = max_width ? max_width.to_f / original.width : Float::INFINITY
        height_ratio = max_height ? max_height.to_f / original.height : Float::INFINITY

        scale_factor = [width_ratio, height_ratio].min

        new_width = (original.width * scale_factor).to_i
        new_height = (original.height * scale_factor).to_i

        [new_width, new_height]
      end

      # Computes the Height & Width from a page's media box. Falls back to the size of the initial image.
      # @param image [MiniMagick::Image] The initial image that will fit into the page.
      # @param media_box [Array<Integer>, nil]
      # @return [Array<Integer>]
      def self.calculate_dimensions_from_media_box(image, media_box)
        if !media_box.nil? && media_box.any?
          [
            media_box[2]&.to_i || image[:width].to_i,
            media_box[3]&.to_i || image[:height].to_i,
          ]
        else
          [image[:width].to_i, image[:height].to_i]
        end
      end

      # Transforms a PDF into a MagickImage. This is currently used for single-page PDFs.
      # @param pdf_stream [StringIO] Input stream.
      # @param image_quality [Integer] Quality to apply to the image.
      # @return [MiniMagick::Image]
      def self.pdf_to_magick_image(pdf_stream, image_quality)
        compressed_image = MiniMagick::Image.read(pdf_stream.read)
        compressed_image.format('jpg')
        compressed_image.quality image_quality.to_s
        compressed_image
      end
    end
  end
end
