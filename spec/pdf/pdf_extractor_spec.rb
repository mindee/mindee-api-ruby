# frozen_string_literal: true

require 'mindee'

describe 'Invoice extraction' do
  let(:invoice_default_sample_path) { File.join(V1_PRODUCT_DATA_DIR, 'invoices', 'default_sample.jpg') }
  let(:invoice_splitter_5p_path) { File.join(V1_PRODUCT_DATA_DIR, 'invoice_splitter', 'invoice_5p.pdf') }
  let(:loaded_prediction_path) { File.join(V1_PRODUCT_DATA_DIR, 'invoice_splitter', 'response_v1', 'complete.json') }

  let(:loaded_prediction) do
    dummy_client = Mindee::Client.new(api_key: 'dummy_key')
    input_response = Mindee::Input::LocalResponse.new(loaded_prediction_path)
    response = dummy_client.load_prediction(Mindee::Product::InvoiceSplitter::InvoiceSplitterV1, input_response)
    response.document.inference.prediction
  end

  it 'should extract a PDF from an image' do
    jpg_input = Mindee::Input::Source::PathInputSource.new(invoice_default_sample_path)
    expect(jpg_input.pdf?).to eq(false)

    extractor = Mindee::PDF::PDFExtractor::PDFExtractor.new(jpg_input)
    expect(extractor.page_count).to eq(1)
  end

  it 'should extract invoices from a PDF (no strict mode)' do
    pdf_input = Mindee::Input::Source::PathInputSource.new(invoice_splitter_5p_path)
    extractor = Mindee::PDF::PDFExtractor::PDFExtractor.new(pdf_input)

    expect(extractor.page_count).to eq(5)

    extracted_pdfs_no_strict = extractor.extract_invoices(loaded_prediction.invoice_page_groups)

    expect(extracted_pdfs_no_strict.length).to eq(3)
    expect(extracted_pdfs_no_strict[0].page_count).to eq(1)
    expect(extracted_pdfs_no_strict[0].filename).to eq('invoice_5p_001-001.pdf')

    expect(extracted_pdfs_no_strict[1].page_count).to eq(3)
    expect(extracted_pdfs_no_strict[1].filename).to eq('invoice_5p_002-004.pdf')

    expect(extracted_pdfs_no_strict[2].page_count).to eq(1)
    expect(extracted_pdfs_no_strict[2].filename).to eq('invoice_5p_005-005.pdf')
  end

  it 'should extract invoices from a PDF (strict mode)' do
    pdf_input = Mindee::Input::Source::PathInputSource.new(invoice_splitter_5p_path)
    extractor = Mindee::PDF::PDFExtractor::PDFExtractor.new(pdf_input)

    expect(extractor.page_count).to eq(5)
    expect(loaded_prediction.invoice_page_groups.length).to eq(3)

    extracted_pdfs_strict = extractor.extract_invoices(loaded_prediction.invoice_page_groups, strict: true)

    expect(extracted_pdfs_strict.length).to eq(2)
    expect(extracted_pdfs_strict[0].page_count).to eq(1)
    expect(extracted_pdfs_strict[0].filename).to eq('invoice_5p_001-001.pdf')

    expect(extracted_pdfs_strict[1].page_count).to eq(4)
    expect(extracted_pdfs_strict[1].filename).to eq('invoice_5p_002-005.pdf')
  end
end
