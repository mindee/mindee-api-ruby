# frozen_string_literal: true

require_relative '../../standard/position_field'

module Mindee
  module Parsing
    module Common
      # Extras namespace.
      module Extras
        # Extra information added to the prediction.
        class Extras
          # @return [CropperExtra, nil]
          attr_reader :cropper
          # @return [Mindee::Parsing::Common::Extras::FullTextOCRExtra, nil]
          attr_reader :full_text_ocr

          def initialize(raw_prediction)
            if raw_prediction['cropper']
              @cropper = Mindee::Parsing::Common::Extras::CropperExtra.new(raw_prediction['cropper'])
            end
            if raw_prediction['full_text_ocr']
              @full_text_ocr = Mindee::Parsing::Common::Extras::FullTextOCRExtra.new(raw_prediction['full_text_ocr'])
            end

            raw_prediction.each do |key, value|
              instance_variable_set("@#{key}", value) unless ['cropper', 'full_text_ocr'].include?(key)
            end
          end

          # @return [String]
          def to_s
            out_str = String.new
            instance_variables.each do |var|
              out_str << "#{var}: #{instance_variable_get(var)}"
            end
            out_str
          end

          # Adds artificial extra data for reconstructed extras. Currently only used for full_text_ocr.
          #
          # @param [Hash] raw_prediction Raw prediction used by the document.
          def add_artificial_extra(raw_prediction)
            return unless raw_prediction['full_text_ocr']

            @full_text_ocr << Mindee::Parsing::Common::Extras::FullTextOCRExtra.new(raw_prediction)
          end
        end

        def empty?
          instance_variables.all? { |var| instance_variable_get(var).nil? }
        end
      end
    end
  end
end
