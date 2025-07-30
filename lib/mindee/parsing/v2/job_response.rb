# frozen_string_literal: true

require_relative 'common_response'
require_relative 'job'

module Mindee
  module Parsing
    module V2
      # HTTP response wrapper that embeds a V2 job.
      class JobResponse < CommonResponse
        # @return [Job] Parsed job payload.
        attr_reader :job

        # @param server_response [Hash] Hash parsed from the API JSON response.
        def initialize(server_response)
          # CommonResponse takes care of the generic metadata (status, etc.)
          super

          @job = Job.new(server_response['job'])
        end

        # Delegates to CommonResponse's string representation and appends the job details.
        #
        # @return [String]
        def to_s
          @job.to_s
        end
      end
    end
  end
end
