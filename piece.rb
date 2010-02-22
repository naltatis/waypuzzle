class Piece
  def initialize line
    @sides = line.split(",")
  end
  
  def to_s
    @sides.join(",")
  end
end