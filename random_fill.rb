require 'lib/field'
require 'lib/piece'

@pieces = []
file = File.new("pieces.txt", "r")
while (line = file.gets)
  @pieces.push(Piece.new(line))
end
file.close

def random_strategy
  number_of_tries = @field.total_places * 5
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

def print_result
  puts "#{@field.full_places.size}/#{@field.total_places} places"
  puts @field 
  puts
end

@field = Field.new(8,8)
random_strategy
print_result

64.times do
  @field = Field.new(12,12)
  total_strategy
  print_result  
end

class Array
  def shuffle
    sort_by { rand }
  end

  def shuffle!
    self.replace shuffle
  end
end