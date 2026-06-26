# frozen_string_literal: true

require_relative 'extracted_image'

module Mindee
  # Image Extraction Module.
  module Image
    # List of extracted images.
    class ExtractedImages < Array
      # Save all extracted images to disk.
      #
      # @param output_path [String, Pathname] Directory path to save the extracted images to.
      def save_all_to_disk(output_path)
        each do |image|
          image.write_to_file(File.join(output_path.to_s, image.filename))
        end
      end
    end
  end
end
