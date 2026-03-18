# frozen_string_literal: true

require 'mindee'
require_relative 'products'

module MindeeCLI
  # Mindee Command Line Interface
  # V1 CLI class.
  class V1Parser
    # @return [Array<String>]
    attr_reader :arguments

    # @return [OptionParser]
    attr_reader :options_parser

    # @return [Parser]
    attr_reader :product_parser

    def initialize(arguments)
      @arguments = arguments
      @options_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: mindee v1 product [options] file'
        opts.separator 'Available products:'
        opts.separator "  #{V1_PRODUCTS.keys.join("\n  ")}"
      end
      @product_parser = init_product_parser
    end

    # @param cli_parser [OptionParser]
    def custom_subcommand(cli_parser)
      cli_parser.on('-v [VERSION]', '--version [VERSION]', 'Model version for the API') do |v|
        @options[:endpoint_version] = v
      end
      cli_parser.on('-a ACCOUNT_NAME', '--account ACCOUNT_NAME', 'API account name for the endpoint') do |v|
        @options[:account_name] = v
      end
    end

    # @return [Hash]
    def init_product_parser
      v1_product_parser = {}
      V1_PRODUCTS.each do |doc_key, doc_value|
        v1_product_parser[doc_key] = OptionParser.new do |options_parser|
          options_parser.on('-w', '--all-words', 'Include words in response') { |v| @options[:all_words] = v }
          options_parser.on('-c', '--cut-pages', 'Cut document pages') { |v| @options[:cut_pages] = v }
          options_parser.on('-k [KEY]', '--key [KEY]', 'API key for the endpoint') { |v| @options[:api_key] = v }
          options_parser.on('-f', '--full', 'Print the full data') { @options[:print_full] = true }
          options_parser.on('-F', '--fix-pdf', 'Repair PDF') { @options[:repair_pdf] = true }

          if doc_key != 'universal'
            options_parser.banner = "Usage: mindee v1 #{doc_key} [options] file"
            custom_subcommand(options_parser)
          end

          if doc_value[:async] && doc_value[:sync]
            options_parser.on('-A', '--async', 'Call asynchronously') { |v| @options[:parse_async] = v }
          end
        end
      end
      v1_product_parser
    end

    # @param product_command [String]
    # @param endpoint_name [String, nil]
    # @param options [Hash]
    # @return [Mindee::Parsing::Common::ApiResponse]
    def send(product_command, endpoint_name, options)
      mindee_client = Mindee::Client.new(api_key: options[:api_key])
      doc_class = V1_PRODUCTS[product_command][:doc_class]
      input_source = setup_input_source(mindee_client, options)
      custom_endpoint = setup_endpoint(mindee_client, product_command, endpoint_name, options)
      page_options = setup_page_options(options)
      options[:parse_async] = !V1_PRODUCTS[product_command][:sync] if options[:parse_async].nil?

      mindee_client.parse(
        input_source,
        doc_class,
        options: { endpoint: custom_endpoint,
                   options: Mindee::ParseOptions.new(
                     params: { page_options: page_options }
                   ),
                   enqueue: options[:parse_async] }
      )
    end

    # @param product_command [String]
    def execute
      options = {}
      product_command = @arguments.shift

      abort(@options_parser.help) unless V1_PRODUCTS.include?(product_command)
      @product_parser[product_command].parse!

      if product_command == 'universal'
        if @arguments.length < 2
          warn "The 'universal' command requires both ENDPOINT_NAME and file arguments."
          abort(@product_parser[product_command].help)
        end
        endpoint_name = @arguments[0]
        options[:file_path] = @arguments[1]
      else
        if @arguments.empty?
          warn 'file missing'
          abort(@product_parser[product_command].help)
        end
        endpoint_name = nil
        options[:file_path] = @arguments[0]
      end

      result = send(product_command, endpoint_name, options)

      puts options[:print_full] ? result.document : result.document.inference.prediction
    end

    private

    # @param mindee_client [Mindee::V1::Client]
    # @param options [Hash]
    # @return [Hash]
    def setup_input_source(mindee_client, options)
      if options[:file_path].start_with?('https://')
        mindee_client.source_from_url(options[:file_path])
      else
        mindee_client.source_from_path(options[:file_path], repair_pdf: options[:repair_pdf])
      end
    end

    # @param mindee_client [Mindee::V1::Client]
    # @param product_command [String]
    # @param endpoint_name [String, nil]
    # @param options [Hash]
    # @return [Mindee::HTTP::Endpoint, nil]
    def setup_endpoint(mindee_client, product_command, endpoint_name, options)
      return unless product_command == 'universal'

      mindee_client.create_endpoint(
        endpoint_name: endpoint_name,
        account_name: options[:account_name],
        version: options[:endpoint_version] || '1'
      )
    end

    # @param options [Hash]
    # @return [Hash]
    def setup_page_options(options)
      if options[:cut_pages].nil? || !options[:cut_pages].is_a?(Integer) ||
         options[:cut_pages].negative?
        nil
      else

        { params: {
          page_indexes: (0..options[:cut_pages].to_i).to_a,
          operation: :KEEP_ONLY,
          on_min_pages: 0,
        } }

      end
    end
  end
end
