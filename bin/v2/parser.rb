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

    # @return [Parser]
    attr_reader :search_parser

    def initialize(arguments)
      @arguments = arguments
      @options_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: mindee v2 command [options]'
      end
      @product_parser = init_product_parser
      @search_parser = init_search_parser
    end

    # Summarize and print the result of the command.
    # @param command [String]
    def print_result(command)
      if command == 'search-models'
        @search_parser.parse!(@arguments)
        result = search(@options)
        summarized_result = output_format == :full ? result.to_s : result.models.to_s
      else
        @product_parser[command].parse!(@arguments)
        @options[:file_path] = @arguments.shift
        if @options[:file_path].nil?
          warn 'file missing'
          abort(@product_parser[command].help)
        end
        result = send(command, @options)
        summarized_result = output_format == :full ? result.inference.to_s : result.inference.result.to_s
      end

      if output_format == :raw
        puts JSON.pretty_generate(raw_payload(result.raw_http))
      else
        puts summarized_result
      end
    end

    # Executes the command.
    # @return [void]
    def execute
      @options = { output_format: :summary }
      command = @arguments.shift

      validate_command!(command)
      print_result(command)
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
      if command == 'search-models'
        abort("#{e.message}\n\n#{@search_parser.help}")
      else
        abort("#{e.message}\n\n#{@product_parser[command].help}")
      end
    end

    private

    def validate_command!(command)
      return if V2_PRODUCTS.include?(command) || command == 'search-models'

      error_msg = "#{@options_parser.help}\nAvailable commands:\n"
      error_msg += "  #{'search-models'.ljust(50)}Search for available models for this API key\n"

      V2_PRODUCTS.each do |product_key, product_values|
        error_msg += "  #{product_key.to_s.ljust(50)}#{product_values[:description]}\n"
      end
      abort(error_msg)
    end

    def init_search_parser
      OptionParser.new do |options_parser|
        options_parser.banner = 'Usage: mindee v2 search-models [options]'
        init_common_options(options_parser)
        options_parser.on('-n [NAME]', '--name [NAME]',
                          'Search for partial matches in model name. Note: case insensitive') do |v|
          @options[:model_name] = v
        end
        options_parser.on('-t [NAME]', '--type [NAME]',
                          'Search for EXACT matches in model type. Note: case sensitive') do |v|
          @options[:model_type] = v
        end
      end
    end

    def setup_specific_options(options_parser, doc_value)
      options_parser.on('-r', '--rag', 'Enable RAG') { @options[:rag] = true } if doc_value.key?(:rag)
      if doc_value.key?(:raw_text)
        options_parser.on('-R', '--raw-text', 'Enable Raw Text retrieval') do
          @options[:raw_text] = true
        end
      end
      if doc_value.key?(:confidence)
        options_parser.on('-c', '--confidence', 'Enable confidence scores') do
          @options[:confidence] = true
        end
      end
      options_parser.on('-p', '--polygon', 'Enable polygons') { @options[:polygon] = true } if doc_value.key?(:polygon)
      if doc_value.key?(:text_context)
        options_parser.on('-t [TEXT CONTEXT]', '--text-context [TEXT CONTEXT]', 'Add Text Context') do |v|
          @options[:text_context] = v
        end
      end
      return unless doc_value.key?(:data_schema)

      options_parser.on('-d [DATA SCHEMA]', '--data-schema [DATA SCHEMA]', 'Add Data Schema') do |v|
        @options[:data_schema] = v
      end
    end

    # Initialize common options for search and product commands.
    # @param options_parser [OptionParser]
    def init_common_options(options_parser)
      options_parser.on('-k [KEY]', '--key [KEY]', 'API key for the endpoint') { |v| @options[:api_key] = v }
      options_parser.on('-o FORMAT', '--output-format FORMAT', ['raw', 'full', 'summary'],
                        'Format of the output (raw, full, summary). Default: summary') do |format|
        @options[:output_format] = format
      end
    end

    # @return [Symbol]
    def output_format
      @options[:output_format]&.to_sym || :summary
    end

    # Handles JSON payloads represented either as a string or an already-parsed hash.
    # Also tolerates one extra JSON encoding layer.
    # @param payload [String, Hash]
    # @return [Hash, Array, String]
    def raw_payload(payload)
      parsed_payload = payload
      2.times do
        break unless parsed_payload.is_a?(String)

        parsed_payload = JSON.parse(parsed_payload)
      rescue JSON::ParserError
        break
      end
      parsed_payload
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
          init_common_options(options_parser)
          options_parser.on('-F', '--fix-pdf', 'Attempt to repair PDF before enqueueing') do
            @options[:repair_pdf] = true
          end
          setup_specific_options(options_parser, product_values)
        end
      end
      v2_product_parser
    end

    # @return [Hash]
    def setup_product_params
      params = { model_id: @options[:model_id] }
      @options.each_pair do |key, value|
        params[key] = value if V2_PRODUCTS['extraction'].include?(key)
      end
      params
    end

    # @param product_command [String]
    # @param options [Hash]
    # @return [Mindee::Parsing::Common::ApiResponse]
    def send(product_command, options)
      mindee_client = Mindee::ClientV2.new(api_key: options[:api_key])
      response_class = V2_PRODUCTS[product_command][:response_class]
      input_source = setup_input_source(options)
      params = setup_product_params

      mindee_client.enqueue_and_get_result(
        response_class,
        input_source,
        params
      )
    end

    # @param options [Hash]
    # @return [Mindee::V2::Parsing::Search::SearchResponse]
    def search(options)
      mindee_client = Mindee::ClientV2.new(api_key: options[:api_key])
      mindee_client.search_models(options[:model_name], options[:model_type])
    end

    # @param options [Hash]
    # @return [Mindee::Input::InputSource]
    def setup_input_source(options)
      if options[:file_path].start_with?('https://')
        Mindee::Input::Source::URLInputSource.new(options[:file_path])
      else
        Mindee::Input::Source::PathInputSource.new(options[:file_path], repair_pdf: options[:repair_pdf])
      end
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
