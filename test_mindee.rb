require_relative 'lib/mindee'

files = Dir['/home/ianare/Documents/tests/*.pdf']
failed_opened = 0

mindee_client = Mindee::Client.new
mindee_client.config_invoice '42e91ae251df3857b32323dae106378d'

t1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
files.each do |file|
  # doc = mindee_client.doc_from_path file
  begin
    doc = mindee_client.doc_from_path file
  rescue
    failed_opened += 1
    puts "=========================\n#{file}\n====================="
  end
  puts doc.parse('invoice')
end
t2 = Process.clock_gettime(Process::CLOCK_MONOTONIC)

total_opened = files.size
success = (total_opened - failed_opened).to_f / total_opened * 100
puts ''
puts "total files: #{total_opened}, failed: #{failed_opened}"
puts "success percentage: #{success}%"
puts "time: #{t2 - t1} secs"
