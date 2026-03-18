# frozen_string_literal: true

require 'mindee/v2/product'

# NOTE: keep product names as string instead of symbols due to kebab-case.

V2_PRODUCTS = {
  'classification' => {
    description: 'Classification Utility',
    response_class: Mindee::V2::Product::Classification::Classification,
    rag: false,
    polygon: false,
    confidence: false,
    raw_text: false,
    text_context: false,
    data_schema: false,
  },
  'extraction' => {
    description: 'Extraction Inference',
    response_class: Mindee::V2::Product::Extraction::Extraction,
    rag: false,
    polygon: false,
    confidence: false,
    raw_text: false,
    text_context: false,
    data_schema: false,
  },
  'crop' => {
    description: 'Crop Utility',
    response_class: Mindee::V2::Product::Crop::Crop,
    rag: false,
    polygon: false,
    confidence: false,
    raw_text: false,
    text_context: false,
    data_schema: false,
  },
  'ocr' => {
    description: 'OCR Utility',
    response_class: Mindee::V2::Product::Ocr::Ocr,
    rag: false,
    polygon: false,
    confidence: false,
    raw_text: true,
    text_context: false,
    data_schema: false,
  },
  'split' => {
    description: 'Split Utility',
    response_class: Mindee::V2::Product::Split::Split,
    rag: false,
    polygon: false,
    confidence: false,
    raw_text: false,
    text_context: false,
    data_schema: false,
  },
}.freeze
