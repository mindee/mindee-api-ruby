# frozen_string_literal: true

require 'mindee/v2/parsing'
require 'mindee/v2/parsing/error_item'
require 'mindee/input/local_response'
require_relative '../../data'

describe Mindee::V2::Parsing::ErrorResponse do
  it 'should load and pretty print an error response' do
    local_response = Mindee::Input::LocalResponse.new(
      File.join(V2_DATA_DIR, 'errors', 'error_422_invalid_fields.json')
    )
    response = local_response.deserialize_response(described_class)

    rst_output = File.read(
      File.join(V2_DATA_DIR, 'errors', 'error_422_invalid_fields.rst')
    )

    expect(response).not_to be_nil
    expect(response.to_s).to eq(rst_output)
  end
end
