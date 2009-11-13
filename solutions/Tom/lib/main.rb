require 'electricity'

all_edges = [
   [ :a, :b, 50],
   [ :a, :d, 150],
   [ :b, :c, 250],
   [ :b, :e, 250],
   [ :c, :e, 350],
   [ :c, :d, 50],
   [ :c, :f, 100],
   [ :d, :f, 400],
   [ :e, :g, 200],
   [ :f, :g, 100],
]

electricity = Electricity.new(all_edges, :a, :g)
unused_edges = electricity.find_unused_edges

puts "Unused edges:"
unused_edges.each {|edge| p edge}