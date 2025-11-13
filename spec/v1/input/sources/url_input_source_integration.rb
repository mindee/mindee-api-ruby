# frozen_string_literal: true

require 'mindee'

describe Mindee::Input::Source::URLInputSource do
  let(:client) { Mindee::Client.new(api_key: ENV.fetch('MINDEE_API_KEY')) }

  it 'retrieves response from a remote file' do
    remote_input = Mindee::Input::Source::URLInputSource.new(ENV.fetch('MINDEE_V2_SE_TESTS_BLANK_PDF_URL'))

    local_input = remote_input.as_local_input_source
    expect(local_input.filename).to eq('blank_1.pdf')

    result = client.parse(local_input, Mindee::Product::Invoice::InvoiceV4)
    expect(result.document.n_pages).to eq(1)
  end

  it 'streams with chunked transfer‐encoding without creating temp files' do
    remote_input = Mindee::Input::Source::URLInputSource
                   .new(ENV.fetch('MINDEE_V2_SE_TESTS_BLANK_PDF_URL'))
    allow(Tempfile).to receive(:new).and_call_original
    allow(Tempfile).to receive(:create).and_call_original

    result = client.parse(remote_input, Mindee::Product::Invoice::InvoiceV4)

    expect(result.document.n_pages).to eq(1)
    expect(Tempfile).not_to have_received(:new)
    expect(Tempfile).not_to have_received(:create)
  end
end
