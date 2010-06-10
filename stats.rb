require 'lib/piece'
require 'pp'

pieces = []
file = File.new("pieces.txt", "r")
while (line = file.gets)
  pieces.push(Piece.new(line.strip))
end
file.close


stats = Hash.new
pieces.each do |piece|
  Piece.directions.each do |direction|
    piece.direction = direction
    
    unless stats.key? piece.top
      stats[piece.top] = 0
    end
    unless stats.key? piece.top.reverse
      stats[piece.top.reverse] = 0
    end

    stats[piece.top] += 1
    stats[piece.top.reverse] -= 1

  end  
end


pp stats