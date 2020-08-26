# graph of distribution of bytes
# 2019-10-11 Naoki F., AIT
# New BSD License is applied. See COPYING file for details.

BLOCK_SIZE = 1000

if ARGV.size != 1
  STDERR.puts "Usage: ruby 8b_graph.rb IN_FILE"
  exit 1
end

dist = Array.new 256, 0
open(ARGV[0], "rb:ASCII-8BIT") do |file|
  while block = file.read(BLOCK_SIZE) do
    block.each_byte{|b| dist[b] += 1 }
  end
end
dist_max = dist.max
one_star = dist_max / 50
exit 0 if dist_max == 0

odd_count  = [[0, 1] * 128, dist].transpose.reduce(0){|s, x| s + x[0] * x[1] }
even_count = [[1, 0] * 128, dist].transpose.reduce(0){|s, x| s + x[0] * x[1] }
total_count = odd_count + even_count
puts "even = %10d (%.3f%%)" % [even_count, 100.0 * even_count / total_count]
puts "odd  = %10d (%.3f%%)" % [odd_count , 100.0 * odd_count  / total_count]
median = 0
while dist[0..median].reduce{|s, x| s + x } < total_count / 2
  median += 1
end
sum  = [(0..255).to_a, dist].transpose.reduce(0){|s, x| s + x[0] * x[1] }
ssum = [(0..255).to_a, dist].transpose.reduce(0){|s, x| s + x[0] * x[0] * x[1] }
puts "avg. = %.2f" % (1.0 * sum / total_count)
puts "s.d. = %.2f" % Math.sqrt(1.0 * ssum / total_count - (1.0 * sum / total_count) ** 2)
puts "med. = %d" % median

puts
puts "[[Graph]]"
omit_mode = false
256.times do |i|
  if omit_mode && (dist[i + 1] || 0) >= one_star
    omit_mode = false
  elsif ! omit_mode && i != 0 && dist[i-1..i+1].max < one_star
    omit_mode = true
    puts "..."
  end
  puts "%02x %s" % [i, '*' * (dist[i] / (one_star))] if ! omit_mode
end