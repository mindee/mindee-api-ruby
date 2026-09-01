# frozen_string_literal: true

require 'mindee'
require_relative 'products'
require_relative 'search_commands'

module MindeeCLI
  # Mindee Command Line Interface
  # V2 CLI class.
  class V2Parser
    include V2SearchCommands

    # @return [Array<String>]
    attr_reader :arguments

    # @return [OptionParser]
    attr_reader :options_parser

    # @return [Parser]
    attr_reader :product_parser

    # @return [Parser]
    attr_reader :search_parser

    # @return [Parser]
    attr_reader :search_rag_docs_parser

    def initialize(arguments, command_prefix: 'mindee v2')
      @arguments = arguments
      @command_prefix = command_prefix
      @options_parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{@command_prefix} command [options]"
      end
      @product_parser = init_product_parser
      @search_parser = init_search_parser
      @search_rag_docs_parser = init_search_rag_docs_parser
    end

    # Summarize and print the result of the command.
    # @param command [String]
    def print_result(command)
      result, summarized_result = if V2_SEARCH_COMMANDS.key?(command)
                                    run_search(command)
                                  else
                                    run_product(command)
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
      abort("#{e.message}\n\n#{command_parser(command).help}")
    rescue Mindee::Error::MindeeError => e
      abort(format_cli_error(e))
    end

    private

    # Parse the arguments and run the given product command.
    # @param command [String]
    # @return [Array(Mindee::V2::Parsing::BaseResponse, String)] Response and its summary.
    def run_product(command)
      @product_parser[command].parse!(@arguments)
      @options[:file_path] = @arguments.shift
      if @options[:file_path].nil?
        warn 'file missing'
        abort(@product_parser[command].help)
      end
      result = send(command, @options)
      summarized_result = output_format == :full ? result.inference.to_s : result.inference.result.to_s
      [result, summarized_result]
    end

    # @param command [String]
    # @return [OptionParser]
    def command_parser(command)
      V2_SEARCH_COMMANDS.key?(command) ? search_parser_for(command) : @product_parser[command]
    end

    def validate_command!(command)
      return if V2_PRODUCTS.include?(command) || V2_SEARCH_COMMANDS.key?(command)

      error_msg = "#{@options_parser.help}\nAvailable commands:\n"
      V2_SEARCH_COMMANDS.each do |search_command, search_values|
        error_msg += "  #{search_command.ljust(50)}#{search_values[:description]}\n"
      end

      V2_PRODUCTS.each do |product_key, product_values|
        error_msg += "  #{product_key.to_s.ljust(50)}#{product_values[:description]}\n"
      end
      abort(error_msg)
    end

    def format_cli_error(error)
      if error.is_a?(Mindee::Error::MindeeHTTPErrorV2) && error.status.to_i == 401
        "CLI error: Missing credentials. Provide an API key using '--key' or " \
          "the 'MINDEE_V2_API_KEY' environment variable."
      elsif error.is_a?(Mindee::Error::MindeeAPIError) && error.message.include?('Missing API key')
        "CLI error: Missing API key. Provide it using '--key' or " \
          "the 'MINDEE_V2_API_KEY' environment variable."
      else
        "CLI error: #{error.message}"
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
      options_parser.on('-k [KEY]', '--key [KEY]', 'Mindee V2 API key.') { |v| @options[:api_key] = v }
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
          options_parser.banner = "Usage: #{@command_prefix} #{product_key} [options] file"
          options_parser.on('-m MODEL_ID', '--model-id MODEL_ID', 'Model ID') { |v| @options[:model_id] = v }
          options_parser.on('-a ALIAS', '--alias ALIAS', 'Add a file alias to the response') do |v|
            @options[:alias] = v
          end
          options_parser.on('-w WEBHOOK_ID', '--webhook-id WEBHOOK_ID',
                            'Specify a webhook by ID. May be used multiple times.') do |v|
            (@options[:webhook_ids] ||= []) << v
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
    def setup_product_params(product_command)
      params = { model_id: @options[:model_id] }
      @options.each_pair do |key, value|
        params[key] = value if V2_PRODUCTS[product_command].include?(key) || %i[alias webhook_ids].include?(key)
      end
      params
    end

    # @param product_command [String]
    # @param options [Hash]
    # @return [Mindee::V1::Parsing::Common::ApiResponse]
    def send(product_command, options)
      mindee_client = Mindee::V2::Client.new(api_key: options[:api_key])
      response_class = V2_PRODUCTS[product_command][:response_class]
      input_source = setup_input_source(options)
      params = setup_product_params(product_command)

      mindee_client.enqueue_and_get_result(
        response_class,
        input_source,
        params
      )
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
