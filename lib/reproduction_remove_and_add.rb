class ReproductionRemoveAndAdd
  def initialize removals
    @num_removals = removals
  end
  
  def mutate field
    pending = []
    rand(@num_removals).times do
      pending.push(remove field)
    end
    pending.shuffle.each do |piece|
      add(piece,field) unless piece.nil?
    end
    field
  end
  
  private
  
  def remove field
    removables = field.removable_places
    place = removables[rand(removables.size)]
    if !place.nil?
      removed = field.get(place[0], place[1])
      field.remove(place[0], place[1])       
    end
    removed
  end
  
  def add piece, field
    places = field.possible_places
    
    places.shuffle.each do |place|
      Piece.directions.shuffle.each do |direction|
        piece.direction = direction
        x,y = place
        
        if field.fits?(x, y, piece)
          field.set x, y, piece
          return
        end
      end
    end
  end
  
end