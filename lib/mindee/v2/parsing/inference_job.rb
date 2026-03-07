# frozen_string_literal: true

require_relative 'common_response'
require_relative 'job'

module Mindee
  module V2
    module Parsing
      # HTTP response wrapper that embeds a V2 job.
      class InferenceJob
        # @return [String] UUID of the Job.
        attr_reader :id

        def initialize(server_response)
          @id = server_response['id']
        end

        # @return [String] String representation of the job.
        def to_s
          "Job\n===\n:ID: #{@id}\n"
        end
      end
    end
  end
end
