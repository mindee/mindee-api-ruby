# frozen_string_literal: true

require 'mindee'

def invoice_splitter_auto_extraction(file_path)
  mindee_client = Mindee::Client.new(api_key: 'my-api-key')
  input_source = mindee_client.source_from_path(file_path)

  if input_source.pdf? && input_source.count_pdf_pages > 1
    parse_multi_page(mindee_client, input_source)
  else
    parse_single_page(mindee_client, input_source)
  end
end

def parse_single_page(mindee_client, input_source)
  invoice_result = mindee_client.parse(
    input_source,
    Mindee::Product::Invoice::InvoiceV4
  )
  puts invoice_result.document
end

def parse_multi_page(mindee_client, input_source)
  pdf_extractor = Mindee::PDF::PDFExtractor::PDFExtractor.new(input_source)
  invoice_splitter_response = mindee_client.enqueue_and_parse(
    input_source,
    Mindee::Product::InvoiceSplitter::InvoiceSplitterV1,
    close_file: false
  )
  page_groups = invoice_splitter_response.document.inference.prediction.invoice_page_groups
  extracted_pdfs = pdf_extractor.extract_invoices(page_groups, strict: false)

  extracted_pdfs.each do |extracted_pdf|
    # Optional: Save the files locally
    # extracted_pdf.write_to_file("output/path")

    invoice_result = mindee_client.parse(
      extracted_pdf.as_input_source,
      Mindee::Product::Invoice::InvoiceV4,
      close_file: false
    )
    puts invoice_result.document
  end
end

my_file_path = '/path/to/the/file.ext'
invoice_splitter_auto_extraction(my_file_path)
