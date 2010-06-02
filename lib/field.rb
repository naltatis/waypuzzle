class Field
  attr_writer :card
  
  def initialize
    @card = Hash.new
  end
  
  def full_places 
    @card.keys.sort
  end
  
  def possible_places
    return [[0,0]] if @card.empty?
    
    possible = []
    full_places.each do |p|
      possible += neighbour_coords p[0], p[1]
    end
    
    (possible - full_places).uniq
  end
  
  def removable_places
    removable = []
    full_places.each do |p|
      removable.push p if removable? p[0], p[1]
    end
    
    removable.uniq
  end
  
  def connections
    c = 0
    b = borders
    (b[:min_y]..b[:max_y]).each do |y|
      (b[:min_x]..b[:max_x]).each do |x|
        c += 1 if !@card[[x,y]].nil? && !@card[[x-1,y]].nil?
        c += 1 if !@card[[x,y]].nil? && !@card[[x,y-1]].nil?
      end
    end
    c
  end
  
  def set x, y, piece
    @card[[x,y]] = piece if fits?(x, y, piece)
  end
  
  def remove x, y
    field = @card[[x,y]]
    @card.delete([x,y])
    field
  end
  
  def get x, y
    @card[[x,y]]
  end
  
  def fits? x, y, piece
    top = @card[[x,y-1]]
    right = @card[[x+1,y]]
    bottom = @card[[x,y+1]]
    left = @card[[x-1,y]]
    
    (possible_places.include? [x,y]) &&
      (top.nil? || piece.fits_top?(top)) &&
      (right.nil? || piece.fits_right?(right)) &&
      (bottom.nil? || piece.fits_bottom?(bottom)) &&
      (left.nil? || piece.fits_left?(left))
  end
  
  def to_s
    out = ""
    to_a.each do |line|
      line.each do |p|
        out += p.nil? ? "-" : "x"
      end      
      out += "\n"
    end
    out
  end
  
  def to_a
    out = []
    b = borders
    (b[:min_y]..b[:max_y]).each do |y|
      line = []
      (b[:min_x]..b[:max_x]).each do |x|
        line.push @card[[x,y]]
      end      
      out.push line
    end
    out
  end
  
  def to_ascii
    rows = []

    grid = to_a
    grid.each_index do |i|
      o = i*5
      5.times { |j| rows[o+j] = "" }
      grid[i].each do |c|
        if !c.nil?
          rows[o+0] += "|-#{c.top[0,1]}-#{c.top[1,2]}-| "
          rows[o+1] += "|#{c.left[1,2]}   #{c.right[0,1]}| "
          rows[o+2] += "|#{c.left[0,1]}   #{c.right[1,2]}| "
          rows[o+3] += "|-#{c.bottom[1,2]}-#{c.bottom[0,1]}-| "
        else
          rows[o+0] += "|-----| "
          rows[o+1] += "|     | "
          rows[o+2] += "|     | "
          rows[o+3] += "|-----| "
        end
      end
    end
    rows.join "\n"
  end
  
  private
  
  def removable? x, y
    if @card.size == 1
      return false
    end
    
    field = remove x, y
    start_x,start_y = full_neighbour_coords(x, y)[0]
    
    part_list = full_neighbour_coords(start_x, start_y)
    10.times do |i|
      part_list.clone.each do |coord|
        full_neighbour_coords(coord[0], coord[1]).each do |n|
          part_list.push n unless part_list.include? n
        end
      end
    end
    
    set x, y, field

    neighbour_fields(x, y).size == 1 || full_places.size == (part_list.size+1)
  end
  
  def borders
    max_x = 0
    max_y = 0
    min_x = 0
    min_y = 0

    @card.each do |key,card|
      unless card.nil?
        x,y = key
        max_x = x if x > max_x
        max_y = y if y > max_y
        min_x = x if x < min_x
        min_y = y if y < min_y
      end
    end
    {:min_x => min_x, :max_x => max_x, :min_y => min_y, :max_y => max_y}
  end
  
  def neighbour_coords x, y
    puts "#{x}-#{y}" if x.nil? || y.nil?
    [[x,y-1],[x+1,y],[x,y+1],[x-1,y]]
  end
  
  def neighbour_fields x,y
    n = []
    neighbour_coords(x,y).each do |field|
      n.push @card[field] if @card.key? field
    end
    n
  end
  
  def full_neighbour_coords x,y
    n = []
    neighbour_coords(x,y).each do |field|
      n.push field if @card.key? field
    end
    n    
  end

  def surrounding_coords x, y
    [[x,y-1],[x+1,y-1],[x+1,y],[x+1,y+1],[x,y+1],[x-1,y+1],[x-1,y],[x-1,y-1]]
  end

  def max_surrounding_streak x,y
    current = 0
    max = 0
    (surrounding_coords(x,y)*2).each do |coord|
      if @card.key? coord
        current += 1
        max = current if current > max
      else
        current = 0
      end
    end
    max
  end

  def has_neighbours x, y
    neighbour_fields(x,y).size > 0
  end
end