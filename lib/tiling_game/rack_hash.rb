# Convert the rack representation in rack.ex to a hash
# of piece designation to the piece's square's offsets.
#
# USAGE:
#   pd lib/tiling_game ; ruby rack_hash.rb >> rack.ex ; pd ; mix docs
#

RACK_EDGE = /\w*\+\-+\+/
RACK_ROW =  /\w*\|(.*)\|/
all = File.read('rack.ex')
rack_section = all.split(RACK_EDGE)[1]
lines = rack_section.split("\n")[1..-2]
rack_rows = lines.map { |row| row.match(RACK_ROW)[1] }
chars = rack_rows.join.split('')

result = {}
chars.each_with_index do |char, index|
  next if char == " "
  result[char] ||= []
  result[char] << index
end

comment = "" # "#  "

puts
puts "  # The following functions are generated by running `ruby rack_hash.rb`"
puts "#{comment}  def width do"
puts "#{comment}    #{rack_rows.first.length}"
puts "#{comment}  end"
puts ""
puts "#{comment}  def height do"
puts "#{comment}    #{lines.length}"
puts "#{comment}  end"
puts ""

puts "#{comment}  def initial_positions do"
puts "#{comment}    #{result.values.flatten.inspect}"
puts "#{comment}  end"
puts ""
puts "#{comment}  def positions do"
puts "#{comment}    %{"
result.each do |key, indexes|
  puts "#{comment}      \"#{key}\" => #{indexes.inspect},"
end
puts "#{comment}      0 => 0" # finsh the map with nonsense
puts "#{comment}  }"
puts "#{comment}  end"
puts "#{comment}end"
puts ""
