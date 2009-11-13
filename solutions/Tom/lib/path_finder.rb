#
# Explore a list of nodes represented as an array of array and find the nodes
# which allow to connect the start with the end
#
class PathFinder
  
  def initialize(edges, start_node, end_node)
    @edges = edges
    @start_node = start_node
    @end_node = end_node
  end

  # return a list of all paths going from start_node to end_node
  def find_all_paths
    found_paths = []
    
    explore(found_paths, nil, @start_node)
    
    found_paths
  end

  # Return a list of edges available for traversal
  def get_next_possible_edges(edges_history, current_node)
    possible_edges = []
    
    @edges.each do |edge|
      if edges_history == nil or edges_history.find {|old_edge| old_edge == edge } == nil
        if current_node == edge[0] or current_node == edge[1]
          possible_edges << edge
        end
      end
    end

    possible_edges
  end


  private

  # explore all possibles path and add successful path in found_paths
  def explore(found_paths, history_of_edges, current_node)
    # if this path goes to the end node, this path is kept
    if current_node == @end_node
      found_paths << history_of_edges
    elsif
      next_edges = get_next_possible_edges(history_of_edges, current_node)
    
      # continue to explore if possible
      if !next_edges.empty?
        next_edges.each do |edge|
          history = []
          history = history_of_edges.dup if history_of_edges != nil
          history << edge
          
          # select next node to visit
          next_node = edge[0]
          if edge[0] == current_node
            next_node = edge[1]
          end
          
          # continue exploration (recursively)
          explore(found_paths, history, next_node)
        end
      end
      
    end
  end
  
end
