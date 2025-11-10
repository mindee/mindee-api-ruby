# frozen_string_literal: true

require 'mindee/input/local_response'
require_relative '../../data'

dummy_secret_key = 'ogNjY44MhvKPGTtVsI8zG82JqWQa68woYQH'
signature = '5ed1673e34421217a5dbfcad905ee62261a3dd66c442f3edd19302072bbf70d0'

FILE_PATH = File.join(V1_DATA_DIR, 'async', 'get_completed_empty.json').freeze

describe Mindee::Input::LocalResponse do
  context 'A local response' do
    it 'should load from a path' do
      response = Mindee::Input::LocalResponse.new(FILE_PATH)
      expect(response.file).to_not be(nil)
      expect(response.valid_hmac_signature?(
               dummy_secret_key, 'invalid signature'
             )).to be(false)
      expect(response.get_hmac_signature(dummy_secret_key)).to eq(signature)
    end

    it 'should load from a string' do
      str_file = File.read(FILE_PATH)
      response = Mindee::Input::LocalResponse.new(str_file)
      expect(response.file).to_not be(nil)
      expect(response.valid_hmac_signature?(
               dummy_secret_key, 'invalid signature'
             )).to be(false)
      expect(response.get_hmac_signature(dummy_secret_key)).to eq(signature)
    end

    it 'should load from a StringIO' do
      strio_file = StringIO.new(File.read(FILE_PATH))
      response = Mindee::Input::LocalResponse.new(strio_file)
      expect(response.file).to_not be(nil)
      expect(response.valid_hmac_signature?(
               dummy_secret_key, 'invalid signature'
             )).to be(false)
      expect(response.get_hmac_signature(dummy_secret_key)).to eq(signature)
    end

    it 'should load from a file-like object' do
      str_file = File.read(FILE_PATH)
      Tempfile.open do |tempfile|
        tempfile.write(str_file)
        tempfile.rewind
        response = Mindee::Input::LocalResponse.new(tempfile)
        expect(response.file).to_not be(nil)
        expect(response.valid_hmac_signature?(
                 dummy_secret_key, 'invalid signature'
               )).to be(false)
        expect(response.get_hmac_signature(dummy_secret_key)).to eq(signature)
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
