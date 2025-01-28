# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'fileutils'

module Mindee
  module Input
    module Source
      # Load a remote document from a file url.
      class UrlInputSource
        # @return [String]
        attr_reader :url

        def initialize(url)
          raise Errors::MindeeInputError, 'URL must be HTTPS' unless url.start_with? 'https://'

          @url = url
        end

        # Downloads the file from the URL and saves it to the specified path.
        #
        # @param path [String] Path to save the file to.
        # @param filename [String, nil] Optional name to give to the file.
        # @param username [String, nil] Optional username for authentication.
        # @param password [String, nil] Optional password for authentication.
        # @param token [String, nil] Optional token for JWT-based authentication.
        # @param max_redirects [Integer] Maximum amount of redirects to follow.
        # @return [String] The full path of the saved file.
        def write_to_file(path, filename: nil, username: nil, password: nil, token: nil, max_redirects: 3)
          response_body = fetch_file_content(username: username, password: password, token: token,
                                             max_redirects: max_redirects)

          filename = fill_filename(filename)

          full_path = File.join(path.chomp('/'), filename)
          File.write(full_path, response_body)

          full_path
        end

        # Downloads the file from the url, and returns a BytesInputSource wrapper object for it.
        #
        # @param filename [String, nil] Optional name to give to the file.
        # @param username [String, nil] Optional username for authentication.
        # @param password [String, nil] Optional password for authentication.
        # @param token [String, nil] Optional token for JWT-based authentication.
        # @param max_redirects [Integer] Maximum amount of redirects to follow.
        # @return [BytesInputSource] The full path of the saved file.
        def as_local_input_source(filename: nil, username: nil, password: nil, token: nil, max_redirects: 3)
          filename = fill_filename(filename)
          response_body = fetch_file_content(username: username, password: password, token: token,
                                             max_redirects: max_redirects)
          bytes = StringIO.new(response_body)

          BytesInputSource.new(bytes.read, filename)
        end

        # Fetches the file content from the URL.
        #
        # @param username [String, nil] Optional username for authentication.
        # @param password [String, nil] Optional password for authentication.
        # @param token [String, nil] Optional token for JWT-based authentication.
        # @param max_redirects [Integer] Maximum amount of redirects to follow.
        # @return [String] The downloaded file content.
        def fetch_file_content(username: nil, password: nil, token: nil, max_redirects: 3)
          uri = URI.parse(@url)
          request = Net::HTTP::Get.new(uri)

          request['Authorization'] = "Bearer #{token}" if token
          request.basic_auth(username, password) if username && password

          response = make_request(uri, request, max_redirects)
          if response.code.to_i > 299
            raise Errors::MindeeAPIError, "Failed to download file: HTTP status code #{response.code}"
          elsif response.code.to_i < 200
            raise Errors::MindeeAPIError, "Failed to download file: Invalid response code #{response.code}."
          end

          response.body
        end

        private

        def extract_filename_from_url(uri)
          filename = File.basename(uri.path)
          filename.empty? ? '' : filename
        end

        def fill_filename(filename)
          filename ||= extract_filename_from_url(URI.parse(@url))
          if filename.empty? || File.extname(filename).empty?
            filename = generate_file_name(extension: get_file_extension(filename))
          end
          filename
        end

        def make_request(uri, request, max_redirects)
          Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            response = http.request(request)
            if response.is_a?(Net::HTTPRedirection) && max_redirects.positive?
              location = response['location']
              raise Errors::MindeeInputError, 'No location in redirection header.' if location.nil?

              new_uri = URI.parse(location)
              request = Net::HTTP::Get.new(new_uri)
              make_request(new_uri, request, max_redirects - 1)
            else
              response
            end
          end
        end

        def get_file_extension(filename)
          ext = File.extname(filename)
          ext.empty? ? nil : ext.downcase
        end

        def generate_file_name(extension: nil)
          extension ||= '.tmp'
          random_string = Array.new(8) { rand(36).to_s(36) }.join
          "mindee_temp_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}_#{random_string}#{extension}"
        end
      end
    end
  end
end
