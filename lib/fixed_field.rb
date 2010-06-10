class FixedField < Field
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    super()
  end
  
  def possible_places
    return all_places if @card.empty?
    
    possible = []
    full_places.each do |p|
      possible += neighbour_coords p[0], p[1]
    end
    
    (possible - full_places).uniq
  end
  
  
  def to_a
    out = []
    b = borders
    @height.times do |y|
      line = []
      @width.times do |x|
        line.push @card[[x,y]]
      end      
      out.push line
    end
    out
  end
  
  private
  
  def neighbour_coords x, y
    puts "#{x}-#{y}" if x.nil? || y.nil?
    neighbours = [[x,y-1],[x+1,y],[x,y+1],[x-1,y]]
    neighbours.select {|a| a[0] < width && a[0] >= 0 && a[1] < height && a[1] >= 0}
  end
  
  def all_places
    all = []
    height.times do |j|
      width.times do |i|
        all.push [i,j]
      end
    end
    all
  end
  

end