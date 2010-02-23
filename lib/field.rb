class Field
  attr_reader :width, :height
  
  def initialize width, height
    @places = Hash.new
    @width = width
    @height = height
    width.times do |x|
      height.times do |y|
        @places[[x+1,y+1]] = nil
      end 
    end
  end
  
  def total_places
    @places.size
  end
  
  def full_places 
    full = @places.clone.delete_if { |k,v| v.nil? }
    full.keys.sort
  end
  
  def possible_places
    free = free_places
    return free if (free.size == total_places)
    
    list = []
    free.each do |p|
      list.push p if has_neighbours p[0], p[1]
    end
    list
  end
  
  def free_places
    free = @places.clone.delete_if { |k,v| !v.nil? }
    free.keys.sort
  end

  def set x, y, piece
    @places[[x,y]] = piece if fits? x, y, piece
  end
  
  def fits? x, y, piece
    top = @places[[x,y-1]]
    right = @places[[x+1,y]]
    bottom = @places[[x,y+1]]
    left = @places[[x-1,y]]

    @places.key?([x,y]) &&
      (full_places.size == 0 || has_neighbours(x,y)) &&
      (!top || top.fits_bottom?(piece)) &&
      (!right || right.fits_left?(piece)) &&
      (!bottom || bottom.fits_top?(piece)) &&
      (!left || left.fits_right?(piece))
  end
  
  def to_s
    out = ""
    @height.times do |y|
      @width.times do |x|
        out += @places[[x+1,y+1]] ? "x" : "-"
      end
      out += "\n"
    end
    out
  end
  
  private
  
  def has_neighbours x, y    
    !@places[[x,y-1]].nil? || !@places[[x+1,y]].nil? ||
    !@places[[x,y+1]].nil? || !@places[[x-1,y]].nil?
  end
end