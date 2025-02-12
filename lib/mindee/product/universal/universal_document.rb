# frozen_string_literal: true

require_relative '../../parsing'
require_relative 'universal_prediction'

module Mindee
  module Product
    module Universal
      # Universal Document V1 prediction
      class UniversalDocument < Mindee::Product::Universal::UniversalPrediction
        include Mindee::Parsing::Standard
        # @param raw_prediction [Hash]
        def initialize(raw_prediction)
          super
          raw_prediction.each do |field_name, field_contents|
            if field_contents.is_a?(Array)
              @fields[field_name] = Parsing::Universal::UniversalListField.new(field_contents)
            elsif field_contents.is_a?(Hash) && Parsing::Universal.universal_object?(field_contents)
              @fields[field_name] = Parsing::Universal::UniversalObjectField.new(field_contents)
            else
              field_contents_str = field_contents.dup
              if field_contents_str.key?('value') && field_contents_str['value'].nil? == false
                field_contents_str['value'] = field_contents_str['value'].to_s
              end
              @fields[field_name] = Mindee::Parsing::Standard::StringField.new(field_contents_str)
            end
          end
        end
      end
    end
  end
end
