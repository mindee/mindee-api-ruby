require_relative 'lib/mindee'

files = Dir['/home/ianare/work/public/mindee-api-ruby/spec/data/receipts/receipt.jpg']
files = Dir['/home/ianare/work/public/mindee-api-ruby/spec/data/invoices/invoice_10p.txt']
failed_opened = 0

mindee_client = Mindee::Client.new
mindee_client.config_invoice('42e91ae251df3857b32323dae106378d')
mindee_client.config_receipt('42e91ae251df3857b32323dae106378d')
mindee_client.config_passport('42e91ae251df3857b32323dae106378d')
mindee_client.config_financial_doc('42e91ae251df3857b32323dae106378d', '42e91ae251df3857b32323dae106378d')

t1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
files.each do |filepath|
  #doc = mindee_client.doc_from_file(File.open(filepath), 'receipt.jpg')
  filedata = File.read(filepath)
  doc = mindee_client.doc_from_b64string(filedata, 'invoice_10p.pdf')
  #puts doc

  response = doc.parse('financial_doc')
  puts response.document
end
t2 = Process.clock_gettime(Process::CLOCK_MONOTONIC)

total_opened = files.size
success = (total_opened - failed_opened).to_f / total_opened * 100
puts ''
puts "total files: #{total_opened}, failed: #{failed_opened}"
puts "success percentage: #{success}%"
puts "time: #{t2 - t1} secs"
