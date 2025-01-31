# frozen_string_literal: true

require 'rspec'
require 'mindee'

describe Mindee::Input::Source::UrlInputSource do
  it 'retrieves response from a remote file' do
    api_key = ENV.fetch('MINDEE_API_KEY', nil)
    client = Mindee::Client.new(api_key: api_key)
    remote_input = Mindee::Input::Source::UrlInputSource.new('https://github.com/mindee/client-lib-test-data/blob/main/products/invoice_splitter/invoice_5p.pdf?raw=true')

    local_input = remote_input.as_local_input_source
    expect(local_input.filename).to eq('invoice_5p.pdf')

    result = client.parse_sync(local_input, Mindee::Product::Invoice::InvoiceV4)
    expect(result.document.n_pages).to eq(5)
  end
end
