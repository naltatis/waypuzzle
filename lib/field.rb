class Field
  attr_reader :width, :height
  
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
      possible += neighbour_fields p[0], p[1]
    end
    
    (possible - full_places).uniq
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
  
  def borders
    max_x = 0
    max_y = 0
    min_x = 0
    min_y = 0

    @card.each do |key,card|
      x,y = key
      max_x = x if x > max_x
      max_y = y if y > max_y
      min_x = x if x < min_x
      min_y = y if y < min_y
    end
    {:min_x => min_x, :max_x => max_x, :min_y => min_y, :max_y => max_y}
  end
  
  def neighbour_fields x, y
    [[x,y-1],[x+1,y],[x,y+1],[x-1,y]]
  end
  
  def has_neighbours x, y
    val = false
    neighbour_fields(x,y).each do |field|
      val = true if @card.key? field
    end
    val
  end
end