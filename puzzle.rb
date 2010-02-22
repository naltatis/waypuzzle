require "piece"

pieces = []
file = File.new("pieces.txt", "r")
while (line = file.gets)
  pieces.push(Piece.new(line))
end
file.close


puts pieces