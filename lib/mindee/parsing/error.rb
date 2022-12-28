module Mindee
  module Parsing
    # API Error
    class Error < StandardError
      # @return [String]
      attr_reader :code
      # @return [String]
      attr_reader :details
      # @return [String]
      attr_reader :message

      def initialize(error)
        @code = error['code']
        @details = error['details']
        @message = error['message']
        super("#{@code}: #{@details} - #{@message}")
      end
    end
  end
end
