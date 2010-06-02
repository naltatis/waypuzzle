require 'json'

class Json
  def to_json field, filename
    File.open(filename, 'w') {|f| f.write(content(field)) }
  end

  private
  
  def content field
    i = Array.new
    field.to_a.each do |line|
      j = Array.new
      line.each do |p|
        if p.nil?
          j.push nil
        else
          j.push Hash[:cardname => p.sides.join(","), :direction => p.direction]
        end 
      end      
      i.push j
    end
    JSON.generate(i)
  end
end