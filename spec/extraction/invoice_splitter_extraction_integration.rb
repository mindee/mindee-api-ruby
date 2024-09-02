# frozen_string_literal: true

require 'mindee'
require 'rspec'
require_relative '../data'
require_relative '../test_utilities'

describe 'PDF Invoice Extraction (Strict Mode)' do
  let(:product_data_dir) { File.join(DATA_DIR, 'products') }
  let(:invoice_splitter_5p_path) { File.join(product_data_dir, 'invoice_splitter', 'invoice_5p.pdf') }

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
      File.join(product_data_dir, 'invoice_splitter', 'default_sample.pdf')
    )
    response = client.enqueue_and_parse(
      invoice_splitter_input, Mindee::Product::InvoiceSplitter::InvoiceSplitterV1, close_file: false
    )
    inference = response.document.inference

    pdf_extractor = Mindee::Extraction::PdfExtractor::PdfExtractor.new(invoice_splitter_input)
    expect(pdf_extractor.page_count).to eq(2)

    extracted_pdfs_strict = pdf_extractor.extract_invoices(inference.prediction.invoice_page_groups, strict: true)

    expect(extracted_pdfs_strict.length).to eq(2)
    expect(extracted_pdfs_strict[0].filename).to eq('default_sample_001-001.pdf')
    expect(extracted_pdfs_strict[1].filename).to eq('default_sample_002-002.pdf')

    invoice0 = client.parse(extracted_pdfs_strict[0].as_input_source, Mindee::Product::Invoice::InvoiceV4)

    test_string_rst_invoice0 = prepare_invoice_return(
      File.join(product_data_dir, 'invoices', 'response_v4', 'summary_full_invoice_p1.rst'),
      invoice0.document
    )

    expect(test_string_rst_invoice0.chomp).to eq(invoice0.document.to_s)
  end
end
