# frozen_string_literal: true

require_relative 'extracted_pdf'

module Mindee
  # PDF Extraction Module.
  module PDF
    # List of extracted PDFs.
    class ExtractedPDFs < Array
      # Save all extracted PDFs to disk.
      #
      # @param output_path [String, Pathname] Directory path to save the extracted PDFs to.
      def save_all_to_disk(output_path)
        each do |pdf|
          pdf.write_to_file(File.join(output_path.to_s, pdf.filename))
        end
      end
    end
  end
end
