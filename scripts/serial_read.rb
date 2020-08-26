# data collection from serial port
# 2019-11-14 Naoki F., AIT
# New BSD License is applied. See COPYING file for details.

require 'rubygems'
require 'serialport'
PORT = "COM5" # modify the port according to environment
BLOCK_SIZE = 4096

# Check Arguments
file_name = ARGV[0]
data_size = ARGV[1] ? ARGV[1].to_i : 0
prog_size = data_size / 50
if ! file_name || data_size <= 0
  STDERR.puts "Usage: ruby serial_read.rb FILE_NAME data_size"
  exit 1
end

# Open Serial Port and Output File
begin
  sp = SerialPort.new(PORT, 3000000, 8, 1, 0)
  sp.read_timeout = 1000
rescue => e
  STDERR.puts "!! failed to open serial port (%s). stop." % e.message
  exit 1
end
begin
  out = open(file_name, "wb:ASCII-8BIT")
rescue => e
  STDERR.puts "!! failed to open output file (%s). stop." % e.message
  exit 1
end

# Read 
total = 0
start = nil
while total < data_size
  data = sp.read(BLOCK_SIZE)
  next if ! data
  out.write(data)
  if total / prog_size != (total + data.size) / prog_size
    print '#'
    STDOUT.flush
  end
  total += data.size
  start = Time.now if !start && total >= data_size / 2
end
elapsed = Time.now - start
sp.close
out.close
puts
puts "Elapsed Time(s): %.3f" % (elapsed * 2)
puts "Transfer Rate (kbit/s): %.3f" % (total / elapsed / 250)