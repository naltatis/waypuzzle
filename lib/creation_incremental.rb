require "lib/field"

class CreationIncremental

  def generate pieces
    field = Field.new
    pieces.shuffle.each do |piece|
      places = field.possible_places

      places.shuffle.each do |place|      
        success = false

        Piece.directions.shuffle.each do |direction|
          piece.direction = direction
          x,y = place

          if field.fits?(x, y, piece)
            field.set x, y, piece
            success = true
          end

          break if success  
        end
        break if success  
      end
    end
    field
  end
end