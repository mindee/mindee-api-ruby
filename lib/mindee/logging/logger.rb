require 'logger'

module Mindee
  module Logging
    @logger = Logger.new($stdout)

    class << self
      attr_writer :logger

      def logger
        @logger
      end
    end
  end
end
