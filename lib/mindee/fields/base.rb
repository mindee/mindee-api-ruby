# frozen_string_literal: true

module Mindee
  # Base field object.
  class Field
    attr_reader :value,
                :confidence,
                :bbox,
                :polygon,
                :page_id,
                :constructed

    def initialize(prediction, page_id, constructed: false)
      @value = prediction['value']
      @confidence = prediction['confidence']
      @bbox = prediction['polygon']
      @polygon = prediction['polygon']
      @page_id = page_id
      @constructed = constructed
    end

    def to_s
      @value ? @value.to_s : ''
    end

    # Multiply confidence of all Mindee::Field in the array.
    def self.array_confidence(field_array)
      product = 1
      field_array.each do |field|
        return 0.0 if field.confidence.nil?

        product *= field.confidence
      end
      product.to_f
    end

    # Add all the Mindee::Field values in the array.
    def self.array_sum(field_array)
      arr_sum = 0
      field_array.each do |field|
        return 0.0 if field.value.nil?

        arr_sum += field.value
      end
      arr_sum.to_f
    end
  end

  class TypedField < Field
    attr_reader :type
  end
end
