# frozen_string_literal: true

require 'mindee'
require 'mindee/extraction'

mindee_client = Mindee::Client.new(api_key: 'my-api-key')
def multi_receipts_detection(file_path, mindee_client)
  input_source = mindee_client.source_from_path(file_path)

  result_split = mindee_client.parse(
    input_source,
    Mindee::Product::MultiReceiptsDetector::MultiReceiptsDetectorV1,
    close_file: false
  )

  images = Mindee::Extraction::MultiReceiptsExtractor.extract_receipts(input_source, result_split.document.inference)
  images.each do |sub_image|
    # Optional: Save the files locally
    # sub_image.write_to_file("/path/to/my/extracted/file/folder")

    result_receipt = mindee_client.parse(
      sub_image.as_source,
      Mindee::Product::Receipt::ReceiptV5,
      close_file: false
    )
    puts result_receipt.document
  end
end

my_file_path = '/path/to/the/file.ext'
multi_receipts_detection(my_file_path, mindee_client)
