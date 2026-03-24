# frozen_string_literal: true

module Mindee
  module V2
    module Parsing
      module Search
        # Array of search models.
        class SearchModels < Array
          def initialize(prediction)
            super(prediction.map { |entry| SearchModel.new(entry) })
          end

          # Default string representation.
          # @return [String]
          def to_s
            return "\n" if empty?

            lines = flat_map do |model|
              [
                "* :Name: #{model.name}",
                "  :ID: #{model.id}",
                "  :Model Type: #{model.model_type}",
              ]
            end

            # Joins all lines with a newline and appends a final newline
            # to perfectly match the C# StringBuilder output.
            "#{lines.join("\n")}\n"
          end
        end
      end
    end
  end
end
