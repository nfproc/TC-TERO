# AIS-31 test suite frontend
# 2020-02-19 - 2023-03-27 Naoki F., AIT
# New BSD License is applied. See COPYING file for details.

require_relative "AIS31.rb"

TESTS = ['ALL', 'A', 'B', 'T0', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T8L']
t = ARGV[0].upcase
outpath = (ARGV.size == 4 && ARGV[2] == '-o') ? ARGV[3] :
          (ARGV.size == 2)                    ? "output.txt" : nil

if (! outpath || ! TESTS.include?(t))
  STDERR.puts "usage: ruby ais_test.rb TEST FILE [-o LOG]"
  exit 1
end

infile = open(ARGV[1], "rb:ASCII-8BIT")
data = ""
len  = 0
while len < 5000000
  break if infile.eof?
  line = infile.read(4096)
  data += line
  len += line.length
end
#data = data.bytes.map{|x| (x % 2 == 1) ? '1' : '0' }.compact.join(nil)

# The output file has just been created.

out_file = File.new(outpath, "w")
data = data.unpack("B*")[0]
Ais31.procedure_a(data, out_file) if t == 'A' || t == 'ALL'
Ais31.procedure_b(data, out_file) if t == 'B' || t == 'ALL'
Ais31.test_t0(data, out_file)     if t == 'T0'
Ais31.test_t1(data, out_file)     if t == 'T1'
Ais31.test_t2(data, out_file)     if t == 'T2'
Ais31.test_t3(data, out_file)     if t == 'T3'
Ais31.test_t4(data, out_file)     if t == 'T4'
Ais31.test_t5(data, out_file)     if t == 'T5'
Ais31.test_t6(data, out_file)     if t == 'T6'
Ais31.test_t7a(data, out_file)    if t == 'T7'
Ais31.test_t7b(data, out_file)    if t == 'T7'
Ais31.test_t7c(data, out_file)    if t == 'T7'
Ais31.test_t8(data, out_file)     if t == 'T8'
Ais31.test_t8(data, out_file, 2560000) if t == 'T8L'