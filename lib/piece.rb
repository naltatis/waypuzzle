class Piece
  def initialize line, direction = :north
    @sides = line.split(",")
    @direction = direction
  end
  
  def to_s
    @sides.join(",")
  end
end