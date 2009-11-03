EDGES = [
   [ 'A', 'B', 50],
   [ 'A', 'D', 150],
   [ 'B', 'C', 250],
   [ 'B', 'E', 250],
   [ 'C', 'E', 350],
   [ 'C', 'D', 50],
   [ 'C', 'F', 100],
   [ 'D', 'F', 400],
   [ 'E', 'G', 200],
   [ 'F', 'G', 100],
]

STARTPOINT = 'A'
ENDPOINT = 'G'
INFINITY = 100000

class Node
  attr_accessor :visited
  attr_accessor :name
  attr_accessor :distance
  attr_accessor :parent
  
  def initialize(name)
    @visited = false
    @distance = INFINITY
    @name = name
    @parent = nil
    @neighbors = []
  end
  
  def to_s
    "#{name} (#{visited}): #{distance} by #{full_path.join("-->")}"
  end
  
  def add_neighbor(node, distance)
    @neighbors << [node, distance]
  end
  
  def dijkstra
    visited = true
    @neighbors.each do |neighbor|
      if !neighbor.first.visited && (neighbor.first.distance > neighbor.last + distance)
        neighbor.first.distance = neighbor.last + distance
        neighbor.first.parent = self
      end
    end
  end
  
  def full_path
    unless parent.nil?
      parent.full_path + [self.name] 
    else
      [self.name]
    end
  end
end

class Graph
  def initialize(edge_arr)
    @nodes = [Node.new(STARTPOINT)]
    @nodes.first.distance = 0
    
    edge_arr.each do |edge|
      node1 = find_or_create_node_by_name(edge[0])
      node2 = find_or_create_node_by_name(edge[1])
      
      node1.add_neighbor(node2, edge.last)
      node2.add_neighbor(node1, edge.last)
    end
  end
  
  def find_or_create_node_by_name(name)
    node = find_node_by_name(name)
    return node unless node.nil?
    
    node = Node.new(name)
    @nodes << node
    node
  end
  
  def find_node_by_name(name)
    @nodes.each do |node|
      return node if node.name == name
    end
    nil
  end
  
  def shortest_path
    @nodes.each do |node|
      node.dijkstra
    end
    find_node_by_name(ENDPOINT).full_path
  end
  
  def redundant_edges
    edges = EDGES
    last = nil
    shortest_path.each do |current|
      unless last.nil?
        edges.each do |arr|
          if arr[0] == last && arr[1] == current ||
             arr[1] == last && arr[0] == current
            edges.delete(arr)
          end
        end
      end
      last = current
    end
    
    edges
  end
end

graph = Graph.new(EDGES)
puts graph.redundant_edges.inspect