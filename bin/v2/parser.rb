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

    # Summarize the result of the command.
    # @param command [String]
    # @return [String]
    def summarize_result(command)
      if command == 'search-models'
        @search_parser.parse!(@arguments)
        @result = search(@options)
        summarized_result = @options[:print_full] ? @result.to_s : @result.models.to_s
      else
        @product_parser[command].parse!(@arguments)
        @options[:file_path] = @arguments.shift
        if @options[:file_path].nil?
          warn 'file missing'
          abort(@product_parser[command].help)
        end
        @result = send(command, @options)
        summarized_result = @options[:print_full] ? @result.inference.to_s : @result.inference.result.to_s
      end
      summarized_result
    end

    # Executes the command.
    # @return [void]
    def execute
      @options = {}
      command = @arguments.shift

      validate_command!(command)
      summarized_result = summarize_result(command)

      if @options[:raw_json]
        puts JSON.pretty_generate(@result.raw_http)
      else
        puts summarized_result
      end
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

    # Initialize common options for search and product commands.
    # @param options_parser [OptionParser]
    def init_common_options(options_parser)
      options_parser.on('-k [KEY]', '--key [KEY]', 'API key for the endpoint') { |v| @options[:api_key] = v }
      options_parser.on('-f', '--full', 'Print the full data') { @options[:print_full] = true }
      options_parser.on('-j', '--raw-json', 'Print the full raw jason data') { @options[:raw_json] = true }
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
          options_parser.on('-C PAGES', '--cut-pages PAGES', 'Cut document pages') { |v| @options[:cut_pages] = v }
          options_parser.on('-F', '--fix-pdf', 'Repair PDF') { @options[:repair_pdf] = true }
          setup_specific_options(options_parser, product_values)
        end
      end
      v2_product_parser
    end

    # @param options [Hash] General options.
    # @return page_options [Hash] Page options.
    def setup_product_params(options, page_options)
      params = { model_id: options[:model_id] }
      params[:options] = Mindee::ParseOptions.new(params: page_options) unless page_options.nil?
      params
    end

    # @param product_command [String]
    # @param options [Hash]
    # @return [Mindee::Parsing::Common::ApiResponse]
    def send(product_command, options)
      mindee_client = Mindee::ClientV2.new(api_key: options[:api_key])
      response_class = V2_PRODUCTS[product_command][:response_class]
      input_source = setup_input_source(options)
      page_options = setup_page_options(options)
      params = setup_product_params(options, page_options)

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
