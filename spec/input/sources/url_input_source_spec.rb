# frozen_string_literal: true

require 'mindee'
require_relative '../../http/mock_http_response'

describe Mindee::Input::Source::UrlInputSource do
  let(:valid_url) { 'https://validurl/some/file.jpg' }
  let(:valid_url_no_filename) { 'https://validurl/some/' }
  let(:invalid_url) { 'http://invalidurl/some/file.jpg' }
  let(:output_dir) { "#{DATA_DIR}/output/" }

  describe '#initialize' do
    context 'with valid URL' do
      it 'creates a new instance' do
        input = described_class.new('https://platform.mindee.com')
        expect(input.url).to eq('https://platform.mindee.com')
      end
    end

    context 'with invalid URL' do
      it 'raises an error for invalid URLs' do
        expect { described_class.new(invalid_url) }.to raise_error(Mindee::Errors::MindeeInputError)
      end
    end
  end

  describe '#as_local_input_source' do
    let(:url_input_source) { described_class.new(valid_url) }
    let(:url_input_source_no_filename) { described_class.new(valid_url_no_filename) }

    before do
      allow(Net::HTTP).to receive(:start).and_return(mock_response)
    end

    context 'when download is successful' do
      let(:mock_response) { MockHTTPResponse.new('1.1', '200', 'OK', 'file content') }

      it 'returns a BytesInputSource' do
        result = url_input_source.as_local_input_source(filename: 'file.pdf')
        expect(result).to be_a(Mindee::Input::Source::BytesInputSource)
        expect(result.filename).to eq('file.pdf')
        expect(result.io_stream).to be_a(StringIO)
        expect(result.io_stream.read).to eq('file content')
      end

      it 'uses a custom filename when provided' do
        result = url_input_source.as_local_input_source(filename: 'custom.pdf')
        expect(result.filename).to eq('custom.pdf')
      end

      it 'handles authentication' do
        result = url_input_source.as_local_input_source(username: 'user', password: 'pass')
        expect(result).to be_a(Mindee::Input::Source::BytesInputSource)
      end
    end

    context 'when download fails' do
      let(:mock_response) { MockHTTPResponse.new('1.1', '404', 'Not Found', '') }

      it 'raises an error' do
        expect do
          url_input_source.as_local_input_source
        end.to raise_error(Mindee::Errors::MindeeAPIError, %r{Failed to download file})
      end
    end
  end

  describe '#write_to_file' do
    let(:url_input_source) { described_class.new(valid_url) }
    let(:url_input_source_no_filename) { described_class.new(valid_url_no_filename) }

    before do
      allow(Net::HTTP).to receive(:start).and_return(mock_response)
      allow(File).to receive(:write)
    end

    context 'when download is successful' do
      let(:mock_response) { MockHTTPResponse.new('1.1', '200', 'OK', 'file content') }

      it 'generates a valid filename when not provided' do
        output_file_path = url_input_source_no_filename.write_to_file(output_dir)
        expect(output_file_path).to match(%r{mindee_temp_\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}_[a-z0-9]{8}\.tmp})
      end

      it 'saves the file with the provided filename' do
        result = url_input_source.write_to_file('/tmp', filename: 'file.pdf')
        expect(result).to eq('/tmp/file.pdf')
        expect(File).to have_received(:write).with('/tmp/file.pdf', 'file content')
      end

      it 'uses a custom filename when provided' do
        result = url_input_source.write_to_file('/tmp', filename: 'custom.pdf')
        expect(result).to eq('/tmp/custom.pdf')
      end

      it 'handles authentication' do
        result = url_input_source_no_filename.write_to_file('/tmp', username: 'user', password: 'pass')
        expect(result).to match(%r{/tmp/mindee_temp_\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}_[a-z0-9]{8}\.tmp})
      end
    end

    context 'when download fails' do
      let(:mock_response) { MockHTTPResponse.new('1.1', '404', 'Not Found', '') }

      it 'raises an error' do
        expect do
          url_input_source.write_to_file('/tmp')
        end.to raise_error(Mindee::Errors::MindeeAPIError, %r{Failed to download file})
      end
    end
  end
end
