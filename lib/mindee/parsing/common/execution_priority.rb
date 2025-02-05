# frozen_string_literal: true

module Mindee
  module Parsing
    module Common
      # Execution policy priority values.
      module ExecutionPriority
        # Low priority execution.
        # @return [Symbol] :low
        LOW = :low
        # Medium priority execution.
        # @return [Symbol] :low
        MEDIUM = :medium
        # High priority execution.
        # @return [Symbol] :low
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
