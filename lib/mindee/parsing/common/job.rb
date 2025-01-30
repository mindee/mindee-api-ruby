# frozen_string_literal: true

require 'time'

module Mindee
  module Parsing
    module Common
      # Job (queue) information on async parsing.
      class Job
        # @return [String] Mindee ID of the document
        attr_reader :id
        # @return [Mindee::Parsing::Standard::DateField]
        attr_reader :issued_at
        # @return [Time, nil]
        attr_reader :available_at
        # @return [JobStatus, Symbol]
        attr_reader :status
        # @return [Integer, nil]
        attr_reader :millisecs_taken
        # @return [Hash, nil]
        attr_reader :error

        # @param http_response [Hash]
        def initialize(http_response)
          @id = http_response['id']
          @error = http_response['error']
          @issued_at = Time.iso8601(http_response['issued_at'])
          if http_response.key?('available_at') && !http_response['available_at'].nil?
            @available_at = Time.iso8601(http_response['available_at'])
            @millisecs_taken = (1000 * (@available_at.to_time - @issued_at.to_time).to_f).to_i
          end
          @status = case http_response['status']
                    when 'waiting'
                      JobStatus::WAITING
                    when 'processing'
                      JobStatus::PROCESSING
                    when 'completed'
                      JobStatus::COMPLETED
                    else
                      http_response['status']&.to_sym
                    end
        end
      end
    end
  end
end
