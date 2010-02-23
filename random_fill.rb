require 'lib/field'
require 'lib/piece'

@pieces = []
file = File.new("pieces.txt", "r")
while (line = file.gets)
  @pieces.push(Piece.new(line))
end
file.close

def random_strategy
  number_of_tries = 1000
  @pieces.each do |piece|
    places = @field.possible_places

    number_of_tries.times do |i|
      piece.direction = Piece.directions[rand(4)]
    
      x,y = places[rand(places.size)]

      if @field.fits?(x, y, piece)
        @field.set x, y, piece
        break
      end
    end
  end
end

def total_strategy
  @pieces.shuffle.each do |piece|
    places = @field.possible_places
    
    places.shuffle.each do |place|      
      success = false
      
      Piece.directions.each do |direction|
        piece.direction = direction
        x,y = place
        
        if @field.fits?(x, y, piece)
          @field.set x, y, piece
          success = true
        end
        
        break if success  
      end
      break if success  
    end
  end
end

def print_result field
  puts "#{field.full_places.size}/#{@pieces.size} places"
  puts field 
  puts
end

@field = Field.new
random_strategy
print_result @field

best = nil
1000.times do
  @field = Field.new
  total_strategy
  best = @field if best.nil? || @field.full_places.size > best.full_places.size
end
print_result best


class Array
  def shuffle
    sort_by { rand }
  end

  def shuffle!
    self.replace shuffle
  end
end