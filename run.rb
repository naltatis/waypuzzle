require 'rubygems'
require "lib/array"
require "lib/evolution"
require 'lib/piece'
require 'lib/creation_incremental'
require 'lib/reproduction_remove_and_add'
require 'lib/benchmark_connections'
require 'lib/benchmark_area'
require 'lib/html'
require 'lib/json'

# open -b com.google.chrome --args --disable-web-security

pieces = []
file = File.new("pieces.txt", "r")
while (line = file.gets)
  pieces.push(Piece.new(line.strip))
end
file.close

e = Evolution.new(6, 10, 100)
e.pieces = pieces
e.creation = CreationIncremental.new
e.reproduction = ReproductionRemoveAndAdd.new(24)
e.benchmark = BenchmarkConnections.new
#e.benchmark = BenchmarkArea.new(1,1)
best = e.perform