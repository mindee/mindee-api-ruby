# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      # Execution policy priority values.
      module ExecutionPriority
        LOW = :low
        MEDIUM = :medium
        HIGH = :high

        # Sets the priority to one of its possibly values, defaults to nil otherwise.
        # @param [String, nil] priority_str
        # @return [Symbol, nil]
        def self.to_priority(priority_str)
          return nil if priority_str.nil?

          case priority_str.downcase
          when 'low'
            :low
          when 'high'
            :high
          else
            :medium
          end
        end
      end
    end
  end
end
