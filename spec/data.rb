# frozen_string_literal: true

DATA_DIR = File.join(__dir__, 'data').freeze

def load_json(dir_path, file_name)
  file_data = File.read(File.join(dir_path, file_name))
  JSON.parse(file_data)
end

def read_file(dir_path, file_name)
  File.read(File.join(dir_path, file_name)).strip
end
