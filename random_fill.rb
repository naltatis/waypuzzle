require 'lib/field'
require 'lib/piece'
require 'lib/html'

pieces = []
file = File.new("pieces.txt", "r")
while (line = file.gets)
  pieces.push(Piece.new(line.strip))
end
file.close

def random_strategy
  number_of_tries = 1000
  pieces.each do |piece|
    places = field.possible_places

    number_of_tries.times do |i|
      piece.direction = Piece.directions[rand(4)]
    
      x,y = places[rand(places.size)]

      if field.fits?(x, y, piece)
        field.set x, y, piece
        break
      end
    end
  end
end

def total_strategy field, pieces
  pieces.shuffle.each do |piece|
    places = field.possible_places
    
    places.shuffle.each do |place|      
      success = false
      
      Piece.directions.each do |direction|
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
end

def print_result field
  puts "#{field.full_places.size} cards | #{field.connections} connection"
  puts field.to_s
  puts

  h = Html.new
  h.to_html field, "result.html"
end

#field = Field.new
#random_strategy
#print_result field

best = 0
fields = []
5000.times do |i|
  fields[i] = Field.new
  total_strategy fields[i], pieces
  if best.nil? || fields[i].connections >= fields[best].connections
    best = i 
    puts "\##{best} #{fields[best].connections} connections"
    print_result fields[i]
  end
end


class Array
  def shuffle
    sort_by { rand }
  end

  def shuffle!
    self.replace shuffle
  end
end