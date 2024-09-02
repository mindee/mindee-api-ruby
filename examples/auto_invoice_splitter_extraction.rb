# frozen_string_literal: true

require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk
input_source = mindee_client.source_from_path('/path/to/the/file.ext')

if input_source.pdf?
  pdf_extractor = Mindee::Extraction::PdfExtractor.new(input_source)
  if pdf_extractor.page_count > 1
    invoice_splitter_response = mindee_client.enqueue_and_parse(
      input_source,
      Mindee::Product::InvoiceSplitter::InvoiceSplitterV1
    )
    page_groups = invoice_splitter_response.document.inference.prediction.invoice_page_groups
    extracted_pdfs = pdf_extractor.extract_invoices(page_groups, strict: false)
    extracted_pdfs.each do |extracted_pdf|
      # Optional: Save the files locally
      # extracted_pdf.write_to_file("output/path")

      invoice_result = mindee_client.parse(
        InvoiceV4,
        extracted_pdf.as_source
      )
      puts invoice_result
    end
  else
    invoice_result = mindee_client.parse(
      input_source,
      Mindee::Product::Invoice::InvoiceV4
    )
    puts invoice_result.document
  end
else
  invoice_result = mindee_client.parse(
    input_source,
    Mindee::Product::Invoice::InvoiceV4
  )
  puts invoice_result.document
end
