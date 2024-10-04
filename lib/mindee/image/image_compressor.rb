# frozen_string_literal: true

module Mindee
  # Image processing module.
  module Image
    # Image compressor module to handle image compression.
    module ImageCompressor
      # Resize and/or compress an SKBitmap. This assumes the ratio was provided before hands.
      # @param image [MiniMagick::Image, StringIO] Input image.
      # @param quality [Integer, nil] Quality of the final file.
      # @param max_width [Integer, nil] Maximum width. If not specified, the horizontal ratio will remain the same.
      # @param max_height [Integer] Maximum height. If not specified, the vertical ratio will remain the same.
      # @return [StringIO]
      def self.compress_image(image, quality: 85, max_width: nil, max_height: nil)
        processed_image = ImageUtils.to_image(image)
        final_width, final_height = ImageUtils.calculate_new_dimensions(
          processed_image,
          max_width: max_width,
          max_height: max_height
        )
        ImageUtils.resize_image(processed_image, final_width, final_height) if final_width || final_height
        ImageUtils.compress_image_quality(processed_image, quality)

        ImageUtils.image_to_stringio(processed_image)
      end
    end
  end
end
