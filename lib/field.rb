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
  
  def set x, y, piece
    @card[[x,y]] = piece if fits? x, y, piece
  end
  
  def fits? x, y, piece
    top = @card[[x,y-1]]
    right = @card[[x+1,y]]
    bottom = @card[[x,y+1]]
    left = @card[[x-1,y]]

    (@card.empty? || has_neighbours(x,y)) &&
      (!top || top.fits_bottom?(piece)) &&
      (!right || right.fits_left?(piece)) &&
      (!bottom || bottom.fits_top?(piece)) &&
      (!left || left.fits_right?(piece))
  end
  
  def to_s
    out = ""
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
    
    (min_x..max_x).each do |x|
      (min_y..max_y).each do |y|
        out += @card[[x,y]].nil? ? "-" : "x"
      end      
      out += "\n"
    end

    out
  end
  
  private
  
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