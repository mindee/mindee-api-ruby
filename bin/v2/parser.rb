# frozen_string_literal: true

require 'mindee'
require_relative 'products'

module MindeeCLI
  # Mindee Command Line Interface
  # V2 CLI class.
  class V2Parser
    # @return [Array<String>]
    attr_reader :arguments

    # @return [OptionParser]
    attr_reader :options_parser

    # @return [Parser]
    attr_reader :product_parser

    def initialize(arguments)
      @arguments = arguments
      @options_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: mindee v2 product [options] filepath'
      end
      @product_parser = init_product_parser
    end

    def setup_specific_options(options_parser, doc_value)
      options_parser.on('-r', '--rag', 'Enable RAG') { @options[:rag] = true } if doc_value[:rag]
      if doc_value[:raw_text]
        options_parser.on('-R', '--raw-text', 'Enable Raw Text retrieval') do
          @options[:raw_text] = true
        end
      end
      if doc_value[:confidence]
        options_parser.on('-c', '--confidence', 'Enable confidence scores') do
          @options[:confidence] = true
        end
      end
      options_parser.on('-p', '--polygon', 'Enable polygons') { @options[:polygon] = true } if doc_value[:polygon]
      if doc_value[:text_context]
        options_parser.on('-t [TEXT CONTEXT]', '--text-context [TEXT CONTEXT]', 'Add Text Context') do |v|
          @options[:text_context] = v
        end
      end
      return unless doc_value[:data_schema]

      options_parser.on('-d [DATA SCHEMA]', '--data-schema [DATA SCHEMA]', 'Add Data Schema') do |v|
        @options[:data_schema] = v
      end
    end

    # @return [Hash]
    def init_product_parser
      v2_product_parser = {}
      V2_PRODUCTS.each do |product_key, product_values|
        v2_product_parser[product_key] = OptionParser.new do |options_parser|
          options_parser.banner = "Usage: mindee v2 #{product_key} [options] file"
          options_parser.on('-m MODEL_ID', '--model-id MODEL_ID', 'Model ID') { |v| @options[:model_id] = v }
          options_parser.on('-a ALIAS', '--alias ALIAS', 'Add a file alias to the response') do |v|
            @options[:alias] = v
          end
          options_parser.on('-C PAGES', '--cut-pages PAGES', 'Cut document pages') { |v| @options[:cut_pages] = v }
          options_parser.on('-k [KEY]', '--key [KEY]', 'API key for the endpoint') { |v| @options[:api_key] = v }
          options_parser.on('-f', '--full', 'Print the full data') { @options[:print_full] = true }
          options_parser.on('-F', '--fix-pdf', 'Repair PDF') { @options[:repair_pdf] = true }
          setup_specific_options(options_parser, product_values)
        end
      end
      v2_product_parser
    end

    def setup_params(options, page_options)
      params = { model_id: options[:model_id] }
      params[:options] = Mindee::ParseOptions.new(params: page_options) unless page_options.nil?
      params
    end

    # @param product_command [String]
    # @param options [Hash]
    # @return [Mindee::Parsing::Common::ApiResponse]
    def send(product_command, _endpoint_name, options)
      mindee_client = Mindee::ClientV2.new(api_key: options[:api_key])
      response_class = V2_PRODUCTS[product_command][:response_class]
      input_source = setup_input_source(options)
      page_options = setup_page_options(options)
      params = setup_params(options, page_options)

      mindee_client.enqueue_and_get_result(
        response_class,
        input_source,
        params
      )
    end

    # @param product_command [String]
    def execute
      @options = {}
      product_command = @arguments.shift

      unless V2_PRODUCTS.include?(product_command)
        error_msg = "#{@options_parser.help}\nAvailable products:\n"
        V2_PRODUCTS.each do |product_key, product_values|
          error_msg += "  #{product_key}#{product_values[:description].rjust(50 - product_key.length, ' ')}\n"
        end
        abort(error_msg)
      end
      @product_parser[product_command].parse!

      if product_command == 'universal'
        if @arguments.length < 2
          warn "The 'universal' command requires both ENDPOINT_NAME and file arguments."
          abort(@product_parser[product_command].help)
        end
        endpoint_name = @arguments[0]
        @options[:file_path] = @arguments[1]
      else
        if @arguments.empty?
          warn 'File missing'
          abort(@product_parser[product_command].help)
        end
        endpoint_name = nil
        @options[:file_path] = @arguments[0]
      end

      result = send(product_command, endpoint_name, @options)

      puts @options[:print_full] ? result.inference : result.inference.result
    end

    private

    # @param options [Hash]
    # @return [Mindee::Input::InputSource]
    def setup_input_source(options)
      if options[:file_path].start_with?('https://')
        Mindee::Input::Source::URLInputSource.new(options[:file_path])
      else
        Mindee::Input::Source::PathInputSource.new(options[:file_path], repair_pdf: options[:repair_pdf])
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
    # @return [Hash, nil]
    def setup_page_options(options)
      if options[:cut_pages].nil? || !options[:cut_pages].is_a?(Integer) ||
         options[:cut_pages].negative?
        nil
      else

        {
          page_indexes: (0..options[:cut_pages].to_i).to_a,
          operation: :KEEP_ONLY,
          on_min_pages: 0,
        }
      end
    end
  end
end
