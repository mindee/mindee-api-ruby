# frozen_string_literal: true

require 'mindee'
require_relative '../../data'
require_relative '../../test_utilities'

describe 'PDF Invoice Extraction (Strict Mode)' do
  let(:invoice_splitter_5p_path) { File.join(V1_PRODUCT_DATA_DIR, 'invoice_splitter', 'invoice_5p.pdf') }

  def prepare_invoice_return(rst_file_path, invoice_prediction)
    rst_content = File.read(rst_file_path)
    parsing_version = invoice_prediction.inference.product.version
    parsing_id = invoice_prediction.id

    rst_content.gsub!(Mindee::TestUtilities.get_version(rst_content), parsing_version)
    rst_content.gsub!(Mindee::TestUtilities.get_id(rst_content), parsing_id)

    rst_content
  end

  it 'should extract invoices from a PDF (strict mode)' do
    client = Mindee::Client.new
    invoice_splitter_input = Mindee::Input::Source::PathInputSource.new(
      File.join(V1_PRODUCT_DATA_DIR, 'invoice_splitter', 'default_sample.pdf')
    )
    response = client.parse(
      invoice_splitter_input, Mindee::Product::InvoiceSplitter::InvoiceSplitterV1, options: { close_file: false }
    )
    inference = response.document.inference

    pdf_extractor = Mindee::PDF::PDFExtractor::PDFExtractor.new(invoice_splitter_input)
    expect(pdf_extractor.page_count).to eq(2)

    extracted_pdfs_strict = pdf_extractor.extract_invoices(inference.prediction.invoice_page_groups, strict: true)

    expect(extracted_pdfs_strict.length).to eq(2)
    expect(extracted_pdfs_strict[0].filename).to eq('default_sample_001-001.pdf')
    expect(extracted_pdfs_strict[1].filename).to eq('default_sample_002-002.pdf')

    invoice0 = client.parse(extracted_pdfs_strict[0].as_input_source, Mindee::Product::Invoice::InvoiceV4)

    test_string_rst_invoice0 = prepare_invoice_return(
      File.join(V1_PRODUCT_DATA_DIR, 'invoices', 'response_v4', 'summary_full_invoice_p1.rst'),
      invoice0.document
    )

    ratio = Mindee::TestUtilities.levenshtein_ratio(invoice0.document.to_s, test_string_rst_invoice0.chomp)
    expect(ratio).to be >= 0.90
  end
end
