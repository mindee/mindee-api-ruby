# frozen_string_literal: true

ROOT_DATA_DIR = File.join(__dir__, 'data').freeze
FILE_TYPES_DIR = File.join(ROOT_DATA_DIR, 'file_types').freeze
V1_DATA_DIR = File.join(ROOT_DATA_DIR, 'v1').freeze
V2_DATA_DIR = File.join(ROOT_DATA_DIR, 'v2').freeze
V1_ASYNC_DIR = File.join(V1_DATA_DIR, 'async').freeze
V1_PRODUCT_DATA_DIR = File.join(V1_DATA_DIR, 'products').freeze
V1_OCR_DIR = File.join(V1_DATA_DIR, 'extras', 'ocr')

def load_json(dir_path, file_name)
  file_data = File.read(File.join(dir_path, file_name))
  JSON.parse(file_data)
end

def read_file(dir_path, file_name)
  File.read(File.join(dir_path, file_name)).strip
end
