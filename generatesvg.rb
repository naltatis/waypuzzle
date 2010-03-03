require 'lib/svg'
require 'lib/piece'

svg = Svg.new

pieces = []
file = File.new("pieces.txt", "r")
while (line = file.gets)
  sides = line.strip.split(",")
  4.times do |i|
    sides = sides.push sides.shift
    svg.to_file Piece.new(sides.join(",")), "svg/"+sides.join(",")+".svg"
  end
end
file.close
