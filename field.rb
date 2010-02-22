class Field
  def initialize width, height
    @places = Hash.new
    width.times do |x|
      height.times do |y|
        @places[[x,y]] = nil
      end
    end
  end
  
  def total_places
    @places.size
  end
  
  def full_places 
    counter = 0
    @places.each { |k,v| counter += 1 if v }
    counter
  end

  def set x, y, piece
    @places[[x,y]] = piece if @places.key? [x,y]
  end
  
  def to_s
    @places
  end
end