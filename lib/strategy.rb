class Strategy
  def initialize field, pieces
    @field = field
    @pieces = pieces
  end
  
  def run
    available_pieces = @pieces.shuffle.deep_clone

    @field.height.times do |y|
      @field.width.times do |x|
        place_piece x, y, available_pieces
      end
    end
    
    @field
  end
  
  private
  
  def place_piece x, y, pieces
    pieces.each do |piece|
      Piece.directions.each do |direction|
        piece.direction = direction
        if @field.fits? x, y, piece
          @field.set x, y, piece 
          pieces.delete piece
          puts pieces.size
          puts @field
          puts 
          break
        end
      end
    end
  end
end