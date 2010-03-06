require "lib/array"
require "lib/evolution"
require 'lib/piece'
require 'lib/creation_incremental'
require 'lib/reproduction_remove_and_add'
require 'lib/benchmark_connections'
require 'lib/html'


pieces = []
file = File.new("pieces.txt", "r")
while (line = file.gets)
  pieces.push(Piece.new(line.strip))
end
file.close

e = Evolution.new(10, 4, 1000)
e.pieces = pieces
e.creation = CreationIncremental.new
e.reproduction = ReproductionRemoveAndAdd.new(5)
e.benchmark = BenchmarkConnections.new
best = e.perform