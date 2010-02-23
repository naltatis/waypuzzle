class Piece
  attr_writer :direction

  
  def initialize line, direction = :north
    @sides = line.split(",")
    @direction = direction
  end
  
  def top
    @sides[offset]
  end
  
  def right
    @sides[1 + offset]
  end

  def bottom
    @sides[2 + offset]
  end

  def left
    @sides[3 + offset]
  end
  
  def fits_top? piece
    top == piece.bottom.reverse
  end
  
  def fits_right? piece
    right == piece.left.reverse
  end
  
  def fits_bottom? piece
    bottom == piece.top.reverse
  end
  
  def fits_left? piece
    left == piece.right.reverse
  end
  
  def to_s
    @sides.join(",")
  end
  
  private
  
  def offset
    - [:north,:east,:south,:west].index(@direction)
  end
end