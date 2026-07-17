# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'fileutils'
require 'ipaddr'
require 'resolv'
require_relative '../../logging'

module Mindee
  module Input
    module Source
      # Load a remote document from a file url.
      class URLInputSource
        # IP ranges that must not be the target of a source URL (SSRF protection).
        DISALLOWED_RANGES = [
          IPAddr.new('127.0.0.0/8'), # IPv4 loopback
          IPAddr.new('::1/128'), # IPv6 loopback
          IPAddr.new('169.254.0.0/16'), # IPv4 link-local
          IPAddr.new('fe80::/10'), # IPv6 link-local
          IPAddr.new('10.0.0.0/8'),     # RFC 1918
          IPAddr.new('172.16.0.0/12'),  # RFC 1918
          IPAddr.new('192.168.0.0/16'), # RFC 1918
          IPAddr.new('0.0.0.0/8'),      # "this" network
          IPAddr.new('224.0.0.0/4'),    # IPv4 multicast
          IPAddr.new('ff00::/8'),        # IPv6 multicast
          IPAddr.new('fc00::/7'),        # IPv6 unique-local
          IPAddr.new('100.64.0.0/10'), # Carrier-grade NAT (RFC 6598)
        ].freeze
        # @return [String]
        attr_reader :url

        def initialize(url)
          validate_url!(url)
          logger.debug("URL input: #{url}")
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

          BytesInputSource.new(bytes.read || '', filename || '')
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
            raise Error::MindeeAPIError, "Failed to download file: HTTP status code #{response.code}"
          elsif response.code.to_i < 200
            raise Error::MindeeAPIError, "Failed to download file: Invalid response code #{response.code}."
          end

          response.body
        end

        private

        # Validates the URL against SSRF risks before it is stored or fetched.
        # Checks scheme, embedded credentials, loopback hostnames, and resolved addresses.
        # @param url [String]
        # @raise [Error::MindeeInputError]
        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
        def validate_url!(url)
          uri = URI.parse(url)

          raise Error::MindeeInputError, 'Only HTTPS source URLs are allowed' unless uri.scheme&.downcase == 'https'

          userinfo = uri.userinfo
          raise Error::MindeeInputError, 'Source URLs must not embed user credentials' if userinfo && !userinfo.empty?

          host = uri.hostname
          raise Error::MindeeInputError, 'Source URL is missing a host' if host.nil? || host.empty?

          lower_host = host.downcase
          if lower_host == 'localhost' || lower_host.end_with?('.localhost') ||
             lower_host == 'ip6-localhost' || lower_host == 'ip6-loopback'
            raise Error::MindeeInputError, "Loopback hostnames are not allowed: #{host}"
          end

          resolved_addresses(host).each do |addr|
            if DISALLOWED_RANGES.any? { |range| range.include?(addr) }
              raise Error::MindeeInputError,
                    "Source URL host resolves to a disallowed address: #{addr}"
            end
          end
        rescue URI::InvalidURIError
          raise Error::MindeeInputError, "Invalid URL: #{url}"
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        # Resolves a host to an array of IPAddr objects.
        # Handles literal IP addresses directly without a DNS round-trip.
        # @param host [String]
        # @return [Array<IPAddr>]
        # @raise [Error::MindeeInputError] if the host cannot be resolved.
        def resolved_addresses(host)
          return [IPAddr.new(host)] if literal_ip?(host)

          addrs = Resolv.getaddresses(host)
          raise Error::MindeeInputError, "Unable to resolve source URL host: #{host}" if addrs.empty?

          addrs.map { |a| IPAddr.new(a) }
        end

        # Returns true if the string is a valid literal IPv4 or IPv6 address.
        # @param host [String]
        def literal_ip?(host)
          IPAddr.new(host)
          true
        rescue IPAddr::InvalidAddressError, IPAddr::AddressFamilyError
          false
        end

        def extract_filename_from_url(uri)
          filename = File.basename(uri.path.to_s)
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
              raise Error::MindeeInputError, 'No location in redirection header.' if location.nil?

              validate_url!(location)
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
