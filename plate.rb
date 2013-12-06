#!/usr/bin/env ruby
name = ARGV[0]

if name.nil?
  STDERR.puts "No name given"
  exit 1
end

command = "stltwalker/stltwalker -b 12 -D -o tmp/name.stl --skew=1,1,1.5 --translate=0,0,1 -p"
name.each_char do |c|
  command << " glyphs/stl/#{c.upcase}.stl"
end
dim_str = `#{command} 2> /dev/null | grep Dimensions`.strip
m = /Dimensions\: (?<x>[^\s]+) x (?<y>[^\s]+) x (?<z>[^\s]+)/.match(dim_str)
exit 1 if m.nil?

puts "Name dimensions X: #{m[:x]} Y: #{m[:y]} Z: #{m[:z]}"

puts "Building base"
command = "stltwalker/stltwalker cube.stl --skew=#{m[:x].to_f + 5},#{m[:y].to_f + 5},4 -o tmp/base.stl 2> /dev/null"
system command

puts "Fusing results"
command = "csgtool/csgtool union tmp/name.stl tmp/base.stl #{name}_plate.stl"
system command

system 'rm tmp/*.stl'
