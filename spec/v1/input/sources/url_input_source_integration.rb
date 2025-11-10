# frozen_string_literal: true

require 'mindee'

describe Mindee::Input::Source::URLInputSource do
  let(:client) { Mindee::Client.new(api_key: ENV.fetch('MINDEE_API_KEY')) }

  it 'retrieves response from a remote file' do
    remote_input = Mindee::Input::Source::URLInputSource.new('https://github.com/mindee/client-lib-test-data/blob/main/v1/products/invoice_splitter/invoice_5p.pdf?raw=true')

    local_input = remote_input.as_local_input_source
    expect(local_input.filename).to eq('invoice_5p.pdf')

    result = client.parse(local_input, Mindee::Product::Invoice::InvoiceV4)
    expect(result.document.n_pages).to eq(5)
  end

  it 'streams with chunked transfer‐encoding without creating temp files' do
    remote_input = Mindee::Input::Source::URLInputSource
                   .new('https://upload.wikimedia.org/wikipedia/commons/1/1d/Blank_Page.pdf')
    allow(Tempfile).to receive(:new).and_call_original
    allow(Tempfile).to receive(:create).and_call_original

    result = client.parse(remote_input, Mindee::Product::Invoice::InvoiceV4)

    expect(result.document.n_pages).to eq(1)
    expect(Tempfile).not_to have_received(:new)
    expect(Tempfile).not_to have_received(:create)
  end
end
