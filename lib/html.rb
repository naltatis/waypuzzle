class Html
  def to_html field, filename
    out = header
    out += table field
    out += footer
    File.open(filename, 'w') {|f| f.write(out) }
  end

  private
  
  def table field
    t = "<h1>#{field.full_places.size} Teile | #{field.connections} Verbindungen</h1>"
    t += "<table>"
    field.to_a.each do |line|
      t += "<tr>"
      line.each do |p|
        t += "<td>"
        t += p.nil? ? "&nbsp;" : "<embed src=\"svg/#{p}.svg\" width=\"100\" height=\"100\">"
        t += "</td>"
      end      
      t += "</tr>"
    end
    t += "</table>"
    t
  end
  
  def header
    "<html><head><meta http-equiv=\"refresh\" content=\"2; URL=result.html\"></head><body>"
  end
  
  def footer
    "</body></html>"
  end
end