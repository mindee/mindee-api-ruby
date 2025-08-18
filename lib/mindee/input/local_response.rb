# frozen_string_literal: true

require 'json'
require 'openssl'
require 'stringio'
require 'pathname'
require 'tempfile'

module Mindee
  module Input
    # Response loaded locally.
    class LocalResponse
      attr_reader :file

      # @param input_file [File, Tempfile, IO, StringIO, String, Pathname] The input file, which can be a StringIO.
      def initialize(input_file)
        case input_file
        when IO, StringIO, File, Tempfile
          str_stripped = input_file.read.to_s.gsub(%r{[\r\n]}, '')
          @file = StringIO.new(str_stripped)
          @file.rewind
        when Pathname, String
          @file = if Pathname(input_file.to_s).exist?
                    StringIO.new(File.read(input_file.to_s, encoding: 'utf-8').gsub(%r{[\r\n]}, ''))
                  else
                    StringIO.new(input_file.to_s.gsub(%r{[\r\n]}, ''))
                  end
          @file.rewind
        else
          raise Errors::MindeeInputError, "Incompatible type for input '#{input_file.class}'."
        end
      end

      # Returns the file as a hash.
      # @return [Hash]
      def as_hash
        @file.rewind
        file_str = @file.read
        JSON.parse(file_str, object_class: Hash)
      rescue JSON::ParserError
        raise Errors::MindeeInputError, "File is not a valid dict. #{file_str}"
      end

      # Processes the secret key
      # @param secret_key [String] the secret key as plain text.
      # @return [String]
      def self.process_secret_key(secret_key)
        secret_key.is_a?(String) ? secret_key.encode('utf-8') : secret_key
      end

      # @param [String] secret_key [String] Secret key, either a string or a byte/byte array.
      # @return [String]
      def get_hmac_signature(secret_key)
        algorithm = OpenSSL::Digest.new('sha256')
        begin
          @file.rewind
          mac = OpenSSL::HMAC.hexdigest(algorithm, self.class.process_secret_key(secret_key), @file.read)
        rescue StandardError
          raise Errors::MindeeInputError, 'Could not get HMAC signature from payload.'
        end
        mac
      end

      # @param secret_key [String] Secret key, either a string or a byte/byte array.
      # @param signature [String] Signature to match
      # @return [bool]
      def valid_hmac_signature?(secret_key, signature)
        signature == get_hmac_signature(secret_key)
      end

      # Deserializes a loaded response
      # @param response_class [Parsing::V2::CommonResponse] class to return.
      # @return [Parsing::V2::JobResponse, Parsing::V2::InferenceResponse]
      def deserialize_response(response_class)
        response_class.new(as_hash) # : Parsing::V2::JobResponse | Parsing::V2::InferenceResponse
      rescue StandardError
        raise Errors::MindeeInputError, 'Invalid response provided.'
      end
    end
  end
end
