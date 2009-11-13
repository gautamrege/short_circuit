require 'path_finder'
  
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
