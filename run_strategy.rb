require 'rubygems'
require "lib/array"
require 'lib/piece'
require 'lib/field'
require 'lib/fixed_field'
require 'lib/strategy'
require 'lib/html'
require 'lib/json'

pieces = []
file = File.new("pieces.txt", "r")
while (line = file.gets)
  pieces.push(Piece.new(line.strip))
end
file.close

s = Strategy.new(FixedField.new(4,4), pieces)
best = s.run
puts best.to_ascii