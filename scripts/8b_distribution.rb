# distribution of bytes
# 2019-06-23 Naoki F., AIT
# New BSD License is applied. See COPYING file for details.

BLOCK_SIZE = 1000

if ARGV.size != 2
  STDERR.puts "Usage: ruby 8b_distribution.rb IN_FILE OUT_FILE"
  exit 1
end

dist_max = 0
open(ARGV[1], "wb") do |out|
  dist = Array.new 256, 0
  open(ARGV[0], "rb:ASCII-8BIT") do |file|
    while block = file.read(BLOCK_SIZE) do
      block.each_byte{|b| dist[b] += 1 }
    end
  end
  dist_max = ([dist_max] + dist).max
  out.puts dist.join(', ')
end
STDERR.puts "## max = %d" % dist_max