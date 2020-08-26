# parameter extraction for parameter searching mode
# 2020-07-28 Naoki F., AIT
# New BSD License is applied. See COPYING file for details.

BLOCK_SIZE = 4096

if ARGV.size != 3
  STDERR.puts "Usage: ruby hex_param_dist.rb IN_FILE AVG STD"
  exit 1
end

dist_min = 32.0
targ_avg = ARGV[1].to_f
targ_std = ARGV[2].to_f
id = 0

open(ARGV[0], "rb:ASCII-8BIT") do |file|
  line = file.gets
  line = line.scan(/......../).map{|x| x.to_i(16) }
  while ! line.empty?
    block = line.shift(2)
    break if block.size != 2
    sat  = (block[0][31] == 1)
    sum  = block[0] & 0xfffff
    ssum = block[1] & 0xfffffff
    avg  = sum.fdiv(BLOCK_SIZE)
    sdev = Math.sqrt(ssum.fdiv(BLOCK_SIZE) - avg * avg)
    if avg >= targ_avg - 16 && avg < targ_avg + 16 && ! sat
      dist = Math.sqrt((avg - targ_avg) ** 2 + (sdev - targ_std) ** 2)
      if dist_min > dist
        puts "## ID = %7d (%05x), avg = %6.2f, std = %6.2f" % [id, id, avg, sdev] 
        dist_min = dist
      end
    end
    id += 1
  end
end