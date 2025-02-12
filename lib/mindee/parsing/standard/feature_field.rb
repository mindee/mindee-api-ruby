# frozen_string_literal: true

module Mindee
  module Parsing
    module Standard
      # Feature field object wrapper for specialized methods.
      class FeatureField < AbstractField
        # Format strings for display by shortening long strings and assigning empty ones.
        # @param in_str [String, bool, nil]
        # @param max_col_size [int, nil]
        # @return [String]
        def format_for_display(in_str, max_col_size = nil)
          return 'True' if in_str == true
          return 'False' if in_str == false
          return '' if in_str.nil?
          return in_str.to_s if max_col_size.nil?

          in_str = in_str.gsub(%r{[\n\r\t]}, "\n" => '\\n', "\r" => '\\r', "\t" => '\\t')
          in_str.to_s.length <= max_col_size.to_i ? in_str.to_s : "#{in_str[0..max_col_size.to_i - 4]}..."
        end
      end
    end
  end
end
