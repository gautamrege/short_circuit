require 'solutions/path_finder'
  
class Electricity
  
  def initialize(edges, start_node, end_node)
    @edges = edges
    @start_node = start_node
    @end_node = end_node
    
    @path_finder = PathFinder.new(@edges, @start_node, @end_node)
  end
  
  # Return a list of edges not traversed by the path of least resistance
  def find_unused_edges
    path_of_least_resistance = find_path_of_least_resistance
    
    # search for all edge not present in the least resistance path
    unused_edges = []
    @edges.each do |edge|
      if path_of_least_resistance.find {|path_edge| path_edge == edge } == nil
        unused_edges << edge
      end
    end
    
    unused_edges
  end
  
  # Return the path with the least cumulative resistance
  def find_path_of_least_resistance
    paths = @path_finder.find_all_paths
    
    path_of_least_resistance = nil
    path_resistance = nil
    
    paths.each do |path|
      resistance = path.inject(0) {|resistance, edge| resistance + edge[2] }
      
      # keep the path with the least resistance
      if path_of_least_resistance == nil || path_resistance == nil || resistance < path_resistance
        path_of_least_resistance = path
        path_resistance = resistance
      end
    end
    
    path_of_least_resistance
  end
  
end

# edited the following for unit-test by ashbb

$test0 =<<EOS
@end_node = :G
@circuits = [
  [:A, :B, 50],
  [:A, :D, 150],
  [:B, :C, 250],
  [:D, :C, 50],
  [:B, :E, 250],
  [:D, :F, 400],
  [:C, :F, 100],
  [:C, :E, 350],
  [:F, :G, 100],
  [:E, :G, 200]
]
EOS

$test1 =<<EOS
@end_node = :H
@circuits = [
   [ :A, :B, 50],
   [ :A, :D, 150],
   [ :B, :C, 250],
   [ :B, :E, 250],
   [ :C, :E, 350],
   [ :C, :D, 50],
   [ :C, :F, 100],
   [ :E, :H, 200],
   [ :F, :H, 100],
   [ :D, :G, 350],
   [ :G, :F, 50],
   [ :C, :G, 30]
]
EOS

$test2 =<<EOS
@end_node = :D
@circuits = [
   [ :A, :B, 10],
   [ :A, :C, 100],
   [ :A, :D, 100],
   [ :B, :C, 10],
   [ :B, :D, 100],
   [ :C, :D, 10]
]
EOS

$test3 =<<EOS
@end_node = :G
@circuits = [
   [ :A, :B, 10],
   [ :A, :C, 100],
   [ :A, :D, 100],
   [ :B, :C, 10],
   [ :B, :D, 100],
   [ :C, :D, 10],
   [ :B, :E, 10],
   [ :C, :F, 10],
   [ :D, :G, 10]
]
EOS


def bridge_method test
  eval test
  Electricity.new(@circuits, :A, @end_node).find_unused_edges.
    collect{|a, b,| a.to_s + b.to_s}
end
  