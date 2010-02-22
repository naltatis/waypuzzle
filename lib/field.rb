class Field
  def initialize width, height
    @places = Hash.new
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
  
  def free_places
    free = @places.clone.delete_if { |k,v| !v.nil? }
    free.keys.sort
  end

  def set x, y, piece
    @places[[x,y]] = piece if @places.key? [x,y]
  end
  
  def fits? x, y, piece
    true
  end
  
  
  def to_s
    @places
  end
end