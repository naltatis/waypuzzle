class Svg
  def from_piece piece
    points = point_hash piece
    
    result = Array.new
    ["f","r","w","s"].each do |type|
      p = points.clone.delete_if {|k,v| v != type}
      case p.size
        when 0
          #puts "no #{type}"
        when 1
          #puts "one #{type}"
        when 
          result.push(connect(p.keys,type))
        else
          #puts "more than 2 #{type}"
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
  
  def connect coords, type
    p1,p2 = coords
    x1,y1 = p1
    x2,y2 = p2

    if ((x1-x2).abs == 1 && y1 == y2) || ((y1-y2).abs == 1 && x1 == x2)
      "<path d=\"M #{x2},#{y2} Q 1.5,1.5 #{x1},#{y1}\" class=\"way_#{type}\" />"
    elsif (x1-x2).abs == 1 && (y1-y2).abs == 1
      ref_x = (x1 > 1.5) ? 2 : 1
      ref_y = (y1 > 1.5) ? 2 : 1
      "<path d=\"M #{x2},#{y2} Q #{ref_x},#{ref_y} #{x1},#{y1}\" class=\"way_#{type}\" />"
    elsif x1 == x2 || y1 == y2
      "<path d=\"M #{x2},#{y2} L #{x1},#{y1}\" class=\"way_#{type}\" />"
    elsif (x1-x2).abs == 1 && (y1-y2).abs == 2 && (x1 == 0 || x1 == 3 || x2 == 0 || x2 == 3)
      sx,ex = (x1 > x2) ? [x1,x2] : [x2,x1]
      sy,ey = (y1 > y2) ? [y1,y2] : [y2,y1]
      ref_y1 = sy-1.5;
      ref_y2 = ey+1.5;
      "<path d=\"M #{x1},#{y1} C #{sx},#{ref_y1} #{ex},#{ref_y2} #{x2},#{y2}\" class=\"way_#{type}\" />"
    elsif (x1-x2).abs == 1 && (y1-y2).abs == 3 && x1 > 0 && x1 < 3
      sx,ex = (x1 > x2) ? [x1,x2] : [x2,x1]
      sy,ey = (y1 > y2) ? [y1,y2] : [y2,y1]
      ref_y1 = sy-1.5;
      ref_y2 = ey+1.5;
      "<path d=\"M #{sx},#{sy} C #{sx},#{ref_y1} #{ex},#{ref_y2} #{ex},#{ey}\" class=\"way_#{type}\" />"
    elsif (y1-y2).abs == 1 && (x1-x2).abs == 3 && y1 > 0 && y1 < 3
      sx,ex = (x1 > x2) ? [x1,x2] : [x2,x1]
      sy,ey = (y1 > y2) ? [y1,y2] : [y2,y1]
      ref_x1 = sx-1.5;
      ref_x2 = ex+1.5;
      "<path d=\"M #{sx},#{sy} C #{ref_x1},#{sy} #{ref_x2},#{ey} #{ex},#{ey}\" class=\"way_#{type}\" />"
    end
  end
  
  def point_hash p
    {
      [1,0] => p.top[0,1],
      [2,0] => p.top[1,2],
      [3,1] => p.right[0,1],
      [3,2] => p.right[1,2],
      [2,3] => p.bottom[0,1],
      [1,3] => p.bottom[1,2],
      [0,2] => p.left[0,1],
      [0,1] => p.left[1,2]
    }
  end
end