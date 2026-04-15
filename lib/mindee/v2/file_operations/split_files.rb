# frozen_string_literal: true

module Mindee
  module V2
    module FileOperation
      # Collection of split files.
      class SplitFiles < Array
        # Save all extracted splits to disk.
        #
        # @param path [String, Pathname] Path to save the extracted splits to.
        # @param prefix [String] Prefix to add to the filename, defaults to 'split'.
        def save_all_to_disk(path, prefix: 'split')
          FileUtils.mkdir_p(path)

          each.with_index(1) do |split, idx|
            filename = "#{prefix}_#{format('%03d', idx)}.pdf"
            file_path = File.join(path.to_s, filename)

            split.write_to_file(file_path)
          end
        end
      end
    end
  end
end
