# Challenge solution.  Doesn't handle multiple shortest paths (just picks first
# one found, i.e. a node has a single predecessor on the shortest path, only
# overwritten when a shorter path is found).
#
# Assumes connections are bidirectional.  Probably better to assume connections
# are directional, and double them up if they happen to be bidirectional.
#
# Problem statement consists of a graph with a start node and and end node.
# Node names are abitrary, so Start_node and End_node must be specified


Connections = [
   [ :A, :B, 50],
   [ :A, :D, 150],
   [ :B, :C, 250],
   [ :B, :E, 250],
   [ :C, :E, 350],
   [ :C, :D, 50],
   [ :C, :F, 100],
   [ :D, :F, 400],
   [ :E, :G, 200],
   [ :F, :G, 100]
]

Start_node = :A
End_node = :G

#Node class tracks a nodes name, shortest distance calcualted so far from Start_node, and
#the node's predecessor on that shortest path
class Node
  attr_accessor :name, :distance, :predecessor

  def initialize(name)
    @name = name
  end
end

class Graph
  def initialize(connections)
    @connections = connections
  end
                                      
  def shortest_path(from, to)
    #Create a new node if we haven't seen that name before                 
    nodes=Hash.new {|h, k| h[k] = Node.new(k)}
    #queue consists of nodes to analyse.  New nodes will be queued only if not previously on the queue
    queue = [Start_node]
    #queued is those nodes previously analysed
    queued = []
    nodes[from].distance = 0
    
    while(!queue.empty?)
      working_node = queue.shift
    
      connections_from(working_node).each do |connection|
    
        #Connections are bi-directional and may be specified either way around
        if connection[0] == working_node
          target = connection[1]
        else
          target = connection[0]
        end  
      
        #shortest path length to target is shortest path length to here, plus final connection
        #if that's shorter than anything discovered so far, store new shortest path and predecessor
        path_distance = nodes[working_node].distance + connection[2]
        if (nodes[target].distance.nil? || path_distance < nodes[target].distance)
          nodes[target].distance = path_distance
          nodes[target].predecessor = working_node
        end
    
        #queue any new neighbor nodes we haven't seen before
        unless queued.include?(target)
          queue.push(target)
          queued.push(target)
        end
      end
    end
    
    # Nodes now labelled with minimal distance
    # i.e. shortest path has been calculated if it exists
    
    # if end node not discovered by now, there is no route from start to end
    return nil unless nodes.has_key?(to)

    # Backtrack from end node until we reach the start node
    # (which we will do, as the end node was discovered)
    shortest = []
    working_node=to
    until working_node == from
      predecessor = nodes[nodes[working_node].predecessor]
    
      # Again, connections are bidirectional and may be specified in either order.
      shortest << @connections.select do |connection|
        (connection[0] == working_node && connection[1] == predecessor.name) ||
        (connection[1] == working_node && connection[0] == predecessor.name)
      end[0]
      
      working_node = predecessor.name
    end

    shortest
  end
  
  def connections_from(node_name)
    @connections.select{|r| r[0] == node_name || r[1] == node_name}
  end
  
  def redundant_connections(from, to)
    #Assumes all paths are redundant if shortest path does not exist
    if (shortest = shortest_path(from, to)).nil?
      return @connections
    else
      return @connections - shortest
    end
       
  end 
end

g = Graph.new(Connections)
p g.redundant_connections(Start_node, End_node)