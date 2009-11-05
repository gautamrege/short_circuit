require 'test/unit'

=begin

  Assumptions: Paths given as input should always indicate the flow of current. 
  For eg: [A, B, 50] should mean current flowing from A to B in circuit. If the above is 
  indicated by [B, A, 50] then the program wont give the desired output.
  
=end

# this function takes as input an array of paths, a source node and a destination node
def find_redundant_resistors(input, src, dest)
  nodes = []
  weight_nodes = Hash.new(1<<32)
  prev_node = {}
  
  # convert the input to form {"node1"=>{"neighbour1"=>7, "neighbour2"=>9}, "node2"=>{"neighbour1"=>5, "neighbour2"=>7,}}
  graph = input.inject({}) do |hash, path|
    hash[path[0]] ||= Hash.new
    hash[path[0]][path[1]] = path[2]
    hash
  end
  
  nodes = graph.keys
  
  # follow the dijkstra algorithm and find least weight and best predecessor of all the nodes
  weight_nodes[src] = 0
  
  until (nodes.empty?)
    # find the node with the minimum weight
    min = nil
    nodes.each do |node|
      min = node if weight_nodes[node] < weight_nodes[min]
    end
    
    break if min.nil?
    
    # update the weight and predecessor of nodes
    nodes = nodes - [min]
    graph[min] and graph[min].keys.each do |v|
      total = weight_nodes[min] + graph[min][v]
      if total < weight_nodes[v]
        weight_nodes[v] = total
        prev_node[v] = min
      end
    end
  end
  
  # find the shortest path and create an array of arrays similar to the format of input
  path = []
  until prev_node[dest].nil?
    path << [prev_node[dest], dest, weight_nodes[dest] - weight_nodes[prev_node[dest]]]
    dest = prev_node[dest]
  end
  
  # return the paths which do not form the shortest path
  input - path
end

# Some testcases
class TestRedundantResistors < Test::Unit::TestCase
  def test_redundant_resistors
    assert_equal(
    find_redundant_resistors(
    [['A','B',50]],
    'A','B'),
    [])
    
    assert_equal(
    find_redundant_resistors(
    [['A','B',50], 
    ['B', 'C', 50], 
    ['A', 'C', 110]],
    'A','C'),
    [['A', 'C', 110]] )
    
    assert_equal( 
    find_redundant_resistors(
    [[ 'A', 'B', 50], 
    [ 'A', 'D', 150], 
    [ 'B', 'C', 250], 
    [ 'B', 'E', 250], 
    [ 'C', 'E', 350], 
    [ 'C', 'F', 100], 
    [ 'D', 'C', 50], 
    [ 'D', 'F', 400], 
    [ 'E', 'G', 200], 
    [ 'F', 'G', 100]],
    'A', 'G' ),
    [["A", "B", 50], 
    ["B", "C", 250], 
    ["B", "E", 250], 
    ["C", "E", 350], 
    ["D", "F", 400], 
    ["E", "G", 200]] )
    
    assert_equal( 
    find_redundant_resistors(
    [[ 'A', 'B', 7], 
    [ 'A', 'C', 9], 
    [ 'A', 'F', 14], 
    [ 'B', 'C', 10], 
    [ 'B', 'D', 15], 
    [ 'C', 'D', 11], 
    [ 'C', 'F', 2], 
    [ 'D', 'E', 6], 
    [ 'F', 'E', 9]], 
    'A', 'E' ),
    [[ 'A', 'B', 7], 
    [ 'A', 'F', 14], 
    [ 'B', 'C', 10], 
    [ 'B', 'D', 15], 
    [ 'C', 'D', 11], 
    [ 'D', 'E', 6]] )
    
    assert_equal( 
    find_redundant_resistors(
    [[ 'A', 'B', 1], 
    [ 'A', 'H', 50], 
    [ 'B', 'I', 60], 
    [ 'B', 'C', 7], 
    [ 'C', 'I', 100], 
    [ 'C', 'D', 2], 
    [ 'D', 'I', 4], 
    [ 'D', 'E', 3], 
    [ 'E', 'I', 10],
    [ 'E', 'F', 200],
    [ 'F', 'I', 50],
    [ 'F', 'G', 80],
    [ 'G', 'I', 70],
    [ 'G', 'H', 90],
    [ 'I', 'H', 5],
    [ 'I', 'A', 15]],
    'A', 'H' ),
    [["A", "H", 50],
     ["B", "I", 60],
     ["C", "I", 100],
     ["D", "E", 3],
     ["E", "I", 10],
     ["E", "F", 200],
     ["F", "I", 50],
     ["F", "G", 80],
     ["G", "I", 70],
     ["G", "H", 90],
     ["I", "A", 15]])

     assert_equal( 
    find_redundant_resistors(
    [[ 'A', 'B', 50], 
    [ 'D', 'A', 150], 
    [ 'B', 'C', 250], 
    [ 'B', 'E', 250], 
    [ 'C', 'E', 350], 
    [ 'C', 'F', 100], 
    [ 'D', 'C', 50], 
    [ 'D', 'F', 400], 
    [ 'G', 'E', 200], 
    [ 'F', 'G', 100]],
    'D', 'E' ),
    [["A", "B", 50], 
    ["D", "A", 150], 
    ["B", "C", 250], 
    ["B", "E", 250], 
    ["C", "F", 100], 
    ["D", "F", 400], 
    ["G", "E", 200], 
    ["F", "G", 100]])
  end
end