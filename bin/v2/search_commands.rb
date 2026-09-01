# frozen_string_literal: true

require 'mindee'

module MindeeCLI
  # Search-related commands for the V2 CLI.
  module V2SearchCommands
    # NOTE: keep command names as string instead of symbols due to kebab-case.
    V2_SEARCH_COMMANDS = {
      'search-models' => {
        description: 'Search for available models for this API key',
        parser: :search_parser,
        runner: :search,
        summary: :models,
      },
      'search-rag-docs' => {
        description: 'Search available RAG documents for a given model',
        parser: :search_rag_docs_parser,
        runner: :search_rag_documents,
        summary: :rag_documents,
      },
    }.freeze

    private

    # Parse the arguments and run the given search command.
    # @param command [String]
    # @return [Array(Mindee::V2::Parsing::Search::BaseSearchResponse, String)] Response and its summary.
    def run_search(command)
      search_command = V2_SEARCH_COMMANDS[command]
      search_parser_for(command).parse!(@arguments)
      result = __send__(search_command[:runner], @options)
      summarized_result = output_format == :full ? result.to_s : result.public_send(search_command[:summary]).to_s
      [result, summarized_result]
    end

    # @param command [String]
    # @return [OptionParser]
    def search_parser_for(command)
      __send__(V2_SEARCH_COMMANDS[command][:parser])
    end

    # @return [OptionParser]
    def init_search_parser
      OptionParser.new do |options_parser|
        options_parser.banner = "Usage: #{@command_prefix} search-models [options]"
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

    # @return [OptionParser]
    def init_search_rag_docs_parser
      OptionParser.new do |options_parser|
        options_parser.banner = "Usage: #{@command_prefix} search-rag-docs [options]"
        init_common_options(options_parser)
        options_parser.on('-m MODEL_ID', '--model-id MODEL_ID', 'Filter by model ID') do |v|
          @options[:model_id] = v
        end
        options_parser.on('-f [FILENAME]', '--filename [FILENAME]',
                          'Filter by file name partial match. Note: case insensitive') do |v|
          @options[:filename] = v
        end
      end
    end

    # @param options [Hash]
    # @return [Mindee::V2::Search::Models::ModelSearchResponse]
    def search(options)
      mindee_client = Mindee::V2::Client.new(api_key: options[:api_key])
      mindee_client.search(
        Mindee::V2::Search::Models::ModelSearchParameters.new(
          name: options[:model_name],
          model_type: options[:model_type]
        )
      )
    end

    # @param options [Hash]
    # @return [Mindee::V2::Search::RAGDocuments::RAGDocumentSearchResponse]
    def search_rag_documents(options)
      mindee_client = Mindee::V2::Client.new(api_key: options[:api_key])
      mindee_client.search(
        Mindee::V2::Search::RAGDocuments::RAGDocumentSearchParameters.new(
          model_id: options[:model_id],
          filename: options[:filename]
        )
      )
    end
  end
end
