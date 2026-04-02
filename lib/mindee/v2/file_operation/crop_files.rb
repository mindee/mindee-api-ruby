# frozen_string_literal: true

module Mindee
  module V2
    module FileOperation
      # Collection of cropped files.
      class CropFiles < Array
        # Save all extracted crops to disk.
        #
        # @param path [String, Pathname] Path to save the extracted crops to.
        # @param prefix [String] Prefix to add to the filename, defaults to 'crop'.
        # @param file_format [String, nil] File format to save the crops as, defaults to jpg if nil.]
        def save_all_to_disk(path, prefix: 'crop', file_format: nil)
          FileUtils.mkdir_p(path)
          each.with_index(1) do |crop, idx|
            filename = "#{prefix}_#{format('%03d', idx)}.jpg"
            file_path = File.join(path.to_s, filename)

            crop.write_to_file(file_path, file_format)
          end
        end
      end
    end
  end
end
