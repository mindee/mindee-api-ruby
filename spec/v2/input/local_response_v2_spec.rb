# frozen_string_literal: true

require 'mindee/input/local_response'
require_relative '../../data'

def assert_local_response(local_response)
  dummy_secret_key = 'ogNjY44MhvKPGTtVsI8zG82JqWQa68woYQH'
  signature = 'f390d9f7f57ac04f47b6309d8a40236b0182610804fc20e91b1f6028aaca07a7'
  expect(local_response.file).to_not be(nil)
  expect(local_response.valid_hmac_signature?(
           dummy_secret_key, 'invalid signature'
         )).to be(false)
  expect(local_response.get_hmac_signature(dummy_secret_key)).to eq(signature)
  inference_response = local_response.deserialize_response(Mindee::Parsing::V2::InferenceResponse)
  expect(inference_response).to be_a(Mindee::Parsing::V2::InferenceResponse)
  expect(inference_response).not_to be_nil
  expect(inference_response.inference).not_to be_nil
end

describe Mindee::Input::LocalResponse do
  let(:file_path) { File.join(V2_DATA_DIR, 'inference', 'standard_field_types.json') }
  context 'A V2 local response' do
    it 'should load from a path' do
      response = Mindee::Input::LocalResponse.new(file_path)
      assert_local_response(response)
    end

    it 'should load from a string' do
      str_file = File.read(file_path)
      response = Mindee::Input::LocalResponse.new(str_file)
      assert_local_response(response)
    end

    it 'should load from a StringIO' do
      strio_file = StringIO.new(File.read(file_path))
      response = Mindee::Input::LocalResponse.new(strio_file)
      assert_local_response(response)
    end

    it 'should load from a file-like object' do
      str_file = File.read(file_path)
      Tempfile.open do |tempfile|
        tempfile.write(str_file)
        tempfile.rewind
        response = Mindee::Input::LocalResponse.new(tempfile)
        assert_local_response(response)
      end
    end

    it 'should trigger an error when something invalid is passed' do
      expect do
        Mindee::Input::LocalResponse.new(123)
      end.to raise_error Mindee::Errors::MindeeInputError
    end

    it 'should trigger an error when the payload is not hashable' do
      local_response = Mindee::Input::LocalResponse.new('Your mother was a hamster.')
      expect do
        local_response.as_hash
      end.to raise_error Mindee::Errors::MindeeInputError
    end
  end
end
