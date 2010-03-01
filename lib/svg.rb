class Svg
  def from_piece piece
    points = point_hash piece
    
    result = Array.new
    ["f","r","w","s"].each do |type|
      p = points.select {|v| v[:type] == type}
      case p.size
        when 0
          #puts "no #{type}"
        when 1
          result.push(ending(p[0][:coord], type))
        when 2
          result.push(connect(p[0][:coord], p[1][:coord], type))
        when 3
          result.push(connect(p[0][:coord], p[1][:coord], type))
          result.push(connect(p[1][:coord], p[2][:coord], type))
        when 4
          result.push(connect(p[0][:coord], p[1][:coord], type))
          result.push(connect(p[2][:coord], p[3][:coord], type))
        else
          puts "#{p.size} types found"
      end
    end
    result
  end
  
  def to_file piece, filename
    c = '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>' +
    '<?xml-stylesheet type="text/css" href="style.css" ?>' +
    '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 3 3">
    	<title>piece</title>
    	<g>'
    c += '<rect x="0" y="0" width="3" height="3" fill="none" stroke="black" stroke-width="0.01" rx="0.07" />'
    c += from_piece(piece).join("\n")
    c += '	</g>
    </svg>'
    File.open(filename, 'w') {|f| f.write(c) }
  end
  
  private
  
  def ending p1, type
    x1,y1 = p1
    if x1 == 0
      ref_x = 1
    elsif x1 == 3
      ref_x = 2
    elsif y1 == 0
      ref_y = 1
    else
      ref_y = 2
    end
    
    ref_x = ref_x || x1
    ref_y = ref_y || y1
    "<path d=\"M #{x1},#{y1} L #{ref_x},#{ref_y}\" class=\"way_#{type}\" />"
  end
  
  def connect p1, p2, type
    x1,y1 = p1
    x2,y2 = p2
    
    # small corner
    if (x1-x2).abs == 1 && (y1-y2).abs == 1
      ref_x = (x1 > 1.5) ? 2 : 1
      ref_y = (y1 > 1.5) ? 2 : 1
      path = "M #{x1},#{y1} Q #{ref_x},#{ref_y} #{x2},#{y2}"
    # large corner
    elsif (x1-x2).abs == 2 && (y1-y2).abs == 2
      ref_x,ref_y = (p1 == [3,1]) ? [x2,y1] : [x1,y2]
      path = "M #{x1},#{y1} Q #{ref_x},#{ref_y} #{x2},#{y2}"
    # turn vertical
    elsif (x1==x2 && (y1-y2).abs == 1)
      ref_x = (x1 == 0) ? 1 : 2
      path = "M #{x1},#{y1} C #{ref_x},#{y1} #{ref_x},#{y2} #{x2},#{y2}"
    # turn horizontal
    elsif (y1==y2 && (x1-x2).abs == 1)
      ref_y = (y1 == 0) ? 1 : 2
      path = "M #{x1},#{y1} C #{x1},#{ref_y} #{x2},#{ref_y} #{x2},#{y2}"
    # straight horizontal
    elsif x1 == x2 || y1 == y2
      path = "M #{x1},#{y1} L #{x2},#{y2}"
    # diagonal
    elsif (x1-x2).abs == 1 && (y1-y2).abs == 3 && x1 > 0 && x1 < 3
      path = "M #{x1},#{y1} C #{x1},1.5 #{x2},1.5 #{x2},#{y2}"
    # diagonal
    elsif (y1-y2).abs == 1 && (x1-x2).abs == 3 && y1 > 0 && y1 < 3
      path = "M #{x1},#{y1} C 1.5,#{y1} 1.5,#{y2} #{x2},#{y2}"
    # long corner
    else
      ref_x1 = (x1 > 1.5) ? 2 : 1
      ref_y1 = (y1 > 1.5) ? 2 : 1
      ref_x2 = (x2 > 1.5) ? 2 : 1
      ref_y2 = (y2 > 1.5) ? 2 : 1
      if [[1,0],[3,1],[2,3],[0,2]].include?(p1)
        path = "M #{x1},#{y1} Q #{ref_x1},#{ref_y1} #{ref_x2},#{ref_y2} L #{x2},#{y2}"
      else
        path = "M #{x1},#{y1} L #{ref_x1},#{ref_y1} Q #{ref_x2},#{ref_y2} #{x2},#{y2}"
      end
    end
    "<path d=\"#{path}\" class=\"way_#{type}\" />"    
  end
  
  def point_hash p
    [ { :coord => [1,0], :type => p.top[0,1] },
      { :coord => [2,0], :type => p.top[1,2] },
      { :coord => [3,1], :type => p.right[0,1] },
      { :coord => [3,2], :type => p.right[1,2] },
      { :coord => [2,3], :type => p.bottom[0,1] },
      { :coord => [1,3], :type => p.bottom[1,2] },
      { :coord => [0,2], :type => p.left[0,1] },
      { :coord => [0,1], :type => p.left[1,2] } ]
  end
end