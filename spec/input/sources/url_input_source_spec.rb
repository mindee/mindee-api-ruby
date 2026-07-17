# frozen_string_literal: true

require 'mindee'
require_relative '../../http/mock_http_response'

describe Mindee::Input::Source::URLInputSource do
  let(:valid_url) { 'https://validurl/some/file.jpg' }
  let(:valid_url_no_filename) { 'https://validurl/some/' }
  let(:invalid_url) { 'http://invalidurl/some/file.jpg' }
  let(:output_dir) { "#{ROOT_DATA_DIR}/output/" }

  # Stub DNS for hosts used in the existing tests so they pass validation.
  before do
    allow(Resolv).to receive(:getaddresses).with('validurl').and_return(['1.2.3.4'])
    allow(Resolv).to receive(:getaddresses).with('platform.mindee.com').and_return(['1.2.3.4'])
  end

  describe '#initialize' do
    context 'with valid URL' do
      it 'creates a new instance' do
        input = described_class.new('https://platform.mindee.com')
        expect(input.url).to eq('https://platform.mindee.com')
      end
    end

    context 'with invalid URL' do
      it 'raises an error for invalid URLs' do
        expect { described_class.new(invalid_url) }.to raise_error(Mindee::Error::MindeeInputError)
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
        end.to raise_error(Mindee::Error::MindeeAPIError, %r{Failed to download file})
      end
    end
  end

  describe '#validate_url!' do
    let(:safe_url) { 'https://safe.example.com/file.pdf' }

    before do
      allow(Resolv).to receive(:getaddresses).with('safe.example.com').and_return(['1.2.3.4'])
    end

    context 'scheme' do
      it 'accepts https' do
        expect { described_class.new(safe_url) }.not_to raise_error
      end

      it 'rejects http' do
        expect { described_class.new('http://safe.example.com/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{Only HTTPS})
      end

      it 'rejects ftp' do
        expect { described_class.new('ftp://safe.example.com/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{Only HTTPS})
      end
    end

    context 'embedded credentials' do
      it 'rejects URLs with user:password' do
        allow(Resolv).to receive(:getaddresses).with('safe.example.com').and_return(['1.2.3.4'])
        expect { described_class.new('https://user:pass@safe.example.com/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{credentials})
      end

      it 'rejects URLs with username only' do
        allow(Resolv).to receive(:getaddresses).with('safe.example.com').and_return(['1.2.3.4'])
        expect { described_class.new('https://user@safe.example.com/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{credentials})
      end
    end

    context 'loopback hostnames' do
      it 'rejects localhost' do
        expect { described_class.new('https://localhost/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{Loopback})
      end

      it 'rejects subdomains of localhost' do
        expect { described_class.new('https://evil.localhost/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{Loopback})
      end

      it 'rejects ip6-localhost' do
        expect { described_class.new('https://ip6-localhost/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{Loopback})
      end

      it 'rejects ip6-loopback' do
        expect { described_class.new('https://ip6-loopback/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{Loopback})
      end
    end

    context 'literal IP addresses' do
      it 'rejects IPv4 loopback (127.0.0.1)' do
        expect { described_class.new('https://127.0.0.1/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects any 127.x.x.x address' do
        expect { described_class.new('https://127.0.0.2/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects IPv6 loopback (::1)' do
        expect { described_class.new('https://[::1]/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects RFC 1918 — 10.x.x.x' do
        expect { described_class.new('https://10.0.0.1/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects RFC 1918 — 172.16.x.x' do
        expect { described_class.new('https://172.16.0.1/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects RFC 1918 — 192.168.x.x' do
        expect { described_class.new('https://192.168.1.1/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects link-local — 169.254.x.x' do
        expect { described_class.new('https://169.254.0.1/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects carrier-grade NAT — 100.64.x.x' do
        expect { described_class.new('https://100.64.0.1/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects any-local — 0.0.0.0' do
        expect { described_class.new('https://0.0.0.0/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects IPv6 unique-local (fc00::1)' do
        expect { described_class.new('https://[fc00::1]/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects IPv6 link-local (fe80::1)' do
        expect { described_class.new('https://[fe80::1]/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end
    end

    context 'hostname resolving to a disallowed address' do
      it 'rejects a hostname that resolves to a private IP' do
        allow(Resolv).to receive(:getaddresses).with('internal.corp').and_return(['192.168.1.50'])
        expect { described_class.new('https://internal.corp/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects a hostname that resolves to a loopback IP' do
        allow(Resolv).to receive(:getaddresses).with('fake-local.example.com').and_return(['127.0.0.1'])
        expect { described_class.new('https://fake-local.example.com/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{disallowed address})
      end

      it 'rejects an unresolvable hostname' do
        allow(Resolv).to receive(:getaddresses).with('unresolvable.invalid').and_return([])
        expect { described_class.new('https://unresolvable.invalid/file.pdf') }
          .to raise_error(Mindee::Error::MindeeInputError, %r{Unable to resolve})
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
        end.to raise_error(Mindee::Error::MindeeAPIError, %r{Failed to download file})
      end
    end
  end
end
