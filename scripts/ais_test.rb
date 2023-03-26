# AIS-31 test suite frontend
# 2020-02-19 Naoki F., AIT
# New BSD License is applied. See COPYING file for details.

require_relative "AIS31.rb"

TESTS = ['ALL', 'A', 'B', 'T0', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T8L']
t = ARGV[0].upcase
if (ARGV.size != 4 || ! TESTS.include?(t) || ARGV[2].to_s != '-o') && (ARGV.size != 2 || ! TESTS.include?(t))
  STDERR.puts "usage: ruby ais_test.rb TEST FILE"
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

if ARGV[2].to_s == '-o'
  out_file = File.new(ARGV[3], "w")
  data = data.unpack("B*")[0]
  Ais31.procedure_a(data, ARGV[3]) if t == 'A' || t == 'ALL'
  Ais31.procedure_b(data, ARGV[3]) if t == 'B' || t == 'ALL'
  Ais31.test_t0(data, ARGV[3])     if t == 'T0'
  Ais31.test_t1(data, ARGV[3])     if t == 'T1'
  Ais31.test_t2(data, ARGV[3])     if t == 'T2'
  Ais31.test_t3(data, ARGV[3])     if t == 'T3'
  Ais31.test_t4(data, ARGV[3])     if t == 'T4'
  Ais31.test_t5(data, ARGV[3])     if t == 'T5'
  Ais31.test_t6(data, ARGV[3])     if t == 'T6'
  Ais31.test_t7a(data, ARGV[3])    if t == 'T7'
  Ais31.test_t7b(data, ARGV[3])    if t == 'T7'
  Ais31.test_t7c(data, ARGV[3])    if t == 'T7'
  Ais31.test_t8(data, ARGV[3])     if t == 'T8'
  Ais31.test_t8(data, ARGV[3], 2560000) if t == 'T8L'
else
  out_file = File.new("output.txt", "w")
  data = data.unpack("B*")[0]
  Ais31.procedure_a(data, "output.txt") if t == 'A' || t == 'ALL'
  Ais31.procedure_b(data, "output.txt") if t == 'B' || t == 'ALL'
  Ais31.test_t0(data, "output.txt")     if t == 'T0'
  Ais31.test_t1(data, "output.txt")     if t == 'T1'
  Ais31.test_t2(data, "output.txt")     if t == 'T2'
  Ais31.test_t3(data, "output.txt")     if t == 'T3'
  Ais31.test_t4(data, "output.txt")     if t == 'T4'
  Ais31.test_t5(data, "output.txt")     if t == 'T5'
  Ais31.test_t6(data, "output.txt")     if t == 'T6'
  Ais31.test_t7a(data, "output.txt")    if t == 'T7'
  Ais31.test_t7b(data, "output.txt")    if t == 'T7'
  Ais31.test_t7c(data, "output.txt")    if t == 'T7'
  Ais31.test_t8(data, "output.txt")     if t == 'T8'
  Ais31.test_t8(data, "output.txt", 2560000) if t == 'T8L'
end