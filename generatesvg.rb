require 'lib/svg'
require 'lib/piece'

svg = Svg.new

pieces = []
file = File.new("pieces.txt", "r")
while (line = file.gets)
  svg.to_file Piece.new(line.strip), "svg/"+line.strip+".svg"
end
file.close
