module ShortestPath
  
  NODES = 0..1 # Nodes are in positions 0 and 1 ['A', 'B', 20]
  LENGTH = 2   # Length is in position 2 
  INFINITY = 1.0/0 # http://weblog.jamisbuck.org/2007/2/7/infinity
  
  # Adds distance method to compute the distance of the current path 
  class Path < Array
    def distance
      (any?)? inject(0) { | sum, edge | sum += edge[LENGTH] } : INFINITY
    end
  end

  # Returns the unused edges between start_node and end_node
  # unused_paths('A', 'B', [['A', 'B', 40], ['A', 'B', 50]]) => ['A', 'B', 50]  
  def unused_paths(start_node, end_node, graph)
    graph - shortest_path(start_node, end_node, graph)
  end

  # Returns the shortest path between start_node and end_node
  # shortest_path('A', 'B', [['A', 'B', 40], ['A', 'B', 50]]) => ['A', 'B', 40]
  def shortest_path(start_node, end_node, graph)
    adjacent_edges = graph.select{ | edge | edge[NODES].include?(start_node) }
    remaining_edges = graph - adjacent_edges
    shortest_path = Path.new
    adjacent_edges.each do | edge |
      path = Path.new [edge]
      neighbor_node = (edge[NODES] - [start_node])[0] # ['A', 'B'] - ['A'] => ['B']
      unless neighbor_node == end_node
        path_ahead = shortest_path(neighbor_node, end_node, remaining_edges)
        (path_ahead.empty?)? path.clear : path.concat(path_ahead)
      end      
      shortest_path = path if path.distance < shortest_path.distance
    end
    shortest_path
  end
      
end

# edited the following for auto_test by ashbb
$test0 =<<EOS
@end_node = 'G'
@circuits = [
  ['A','B',50],
  ['A','D',150],
  ['B','C',250],
  ['D','C',50],
  ['B','E',250],
  ['D','F',400],
  ['C','F',100],
  ['C','E',350],
  ['F','G',100],
  ['E','G',200]
]
EOS

$test1 =<<EOS
@end_node = 'H'
@circuits = [
   [ 'A', 'B', 50],
   [ 'A', 'D', 150],
   [ 'B', 'C', 250],
   [ 'B', 'E', 250],
   [ 'C', 'E', 350],
   [ 'C', 'D', 50],
   [ 'C', 'F', 100],
   [ 'E', 'H', 200],
   [ 'F', 'H', 100],
   [ 'D', 'G', 350],
   [ 'G', 'F', 50],
   [ 'C', 'G', 30]
]
EOS

$test2 =<<EOS
@end_node = 'D'
@circuits = [
   [ 'A', 'B', 10],
   [ 'A', 'C', 100],
   [ 'A', 'D', 100],
   [ 'B', 'C', 10],
   [ 'B', 'D', 100],
   [ 'C', 'D', 10]
]
EOS

$test3 =<<EOS
@end_node = 'G'
@circuits = [
   [ 'A', 'B', 10],
   [ 'A', 'C', 100],
   [ 'A', 'D', 100],
   [ 'B', 'C', 10],
   [ 'B', 'D', 100],
   [ 'C', 'D', 10],
   [ 'B', 'E', 10],
   [ 'C', 'F', 10],
   [ 'D', 'G', 10]
]
EOS


def bridge_method test
  eval test
  extend ShortestPath
  p shortest_path('A', @end_node, @circuits)
  unused_paths('A', @end_node, @circuits).collect{|a, b,| a + b}
end

