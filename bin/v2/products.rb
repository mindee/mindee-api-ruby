# frozen_string_literal: true

require 'mindee/v2/product'

# NOTE: keep product names as string instead of symbols due to kebab-case.

V2_PRODUCTS = {
  'classification' => {
    description: 'Classification Utility',
    response_class: Mindee::V2::Product::Classification::Classification,
  },
  'extraction' => {
    description: 'Extraction Inference',
    response_class: Mindee::V2::Product::Extraction::Extraction,
    rag: true,
    polygon: true,
    confidence: true,
    raw_text: true,
    text_context: true,
    data_schema: true,
  },
  'crop' => {
    description: 'Crop Utility',
    response_class: Mindee::V2::Product::Crop::Crop,
  },
  'ocr' => {
    description: 'OCR Utility',
    response_class: Mindee::V2::Product::Ocr::Ocr,
  },
  'split' => {
    description: 'Split Utility',
    response_class: Mindee::V2::Product::Split::Split,
  },
}.freeze
