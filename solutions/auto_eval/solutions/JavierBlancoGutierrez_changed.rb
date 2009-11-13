=begin
require "test/unit"
class TestFindRedundantResistors < Test::Unit::TestCase
  def test_find_redundant_resistors
    actual = find_redundant_resistors [
                                         [ 'A', 'B',  50],
                                         [ 'A', 'D', 150],
                                         [ 'B', 'C', 250],
                                         [ 'B', 'E', 250],
                                         [ 'C', 'E', 350],
                                         [ 'C', 'D',  50],
                                         [ 'C', 'F', 100],
                                         [ 'D', 'F', 400],
                                         [ 'E', 'G', 200],
                                         [ 'F', 'G', 100],
                                      ]
    expected = [
                 [ 'A', 'B',  50],
                 [ 'B', 'C', 250],
                 [ 'B', 'E', 250],
                 [ 'C', 'E', 350],
                 [ 'D', 'F', 400],
                 [ 'E', 'G', 200],
               ]
    assert_equal(expected, actual)
  end
end
=end

def find_redundant_resistors(resistors, e)   # edited for auto_check by ashbb
  circuit = Graph.new(resistors)
  least_resistance_path = circuit.shortest_path('A', e)  # eidted for auto_check by ashbb
  redundant_resistors = resistors.dup
  (least_resistance_path.size - 1).times do |i|
    from, to = least_resistance_path[i], least_resistance_path[i + 1]
    redundant_resistors.reject! do |r| # remove this resistence from the circuit
      to.name == r[0] && from.name == r[1] or
      to.name == r[1] && from.name == r[0]
    end
  end
  redundant_resistors
end

##
# Graph class
class Graph

  attr_reader :vertices

  def initialize(distances)
    @vertices = {}
    distances.each {|distance| add(*distance) }
  end  
  
  def shortest_path(from, to)
    origen, destiny = self.vertices[from], self.vertices[to]
    origen.find_shortest_path_to(destiny)
  end

  private

  ##
  # Adds distance info between two vertices in the graph
  def add(source_name, target_name, distance)
    target = @vertices[target_name] ||= Vertex.new(target_name)
    source = @vertices[source_name] ||= Vertex.new(source_name)
    source.connections[target] = distance
    target.connections[source] = distance
  end

end

##
# Vertex class
class Vertex

  attr_reader :name
  
  # Hash containing the the distances to the vertices connected to the current vertex
  attr_reader :connections

  ##
  # Constructor
  def initialize(name)
    @name = name
    @connections = {}
  end  

  ##
  # Dijkstra's terms
  attr_reader :shortest_connections_to_origin
  attr_reader :shortest_distance_to_origin

  ##
  # Dijkstra's algorithm
  def find_shortest_path_to(destiny)
    @shortest_distance_to_origin = 0
    temporary_vertices, checked_vertices = [ self ], []
    
    while !temporary_vertices.empty?
      # pick next vertex among the temporary vertices who offers the shortest distance to origin
      min_shortest_distance_to_origin = temporary_vertices.map { |t| t.shortest_distance_to_origin }.compact.min
      current_vertex = temporary_vertices.find { |t| t.shortest_distance_to_origin == min_shortest_distance_to_origin }
      
      # if current vertex offers his connections a shortest path to origin they will update shortest path info
      current_vertex.connections.keys.each do |v|
        v.check_distance_through(current_vertex)
        temporary_vertices << v
      end
      
      checked_vertices << current_vertex
      temporary_vertices -= checked_vertices
    end

    # although each vertix can contain multiple min paths to origin i will pick just one
    shortest_path = [ destiny ]
    current_vertex = destiny
    while !shortest_path.include?(self)
      current_vertex = current_vertex.shortest_connections_to_origin.first
      shortest_path.push current_vertex
    end
    shortest_path
  end
  
  protected
  
  ##
  # Checks whether the distance to the origin through this vertex is shortest than the ones visited earlier
  def check_distance_through(vertex)
    shortest_distance_to_origin_through_vertex = (vertex.shortest_distance_to_origin || 0) + @connections[vertex]
    if @shortest_distance_to_origin.nil? || shortest_distance_to_origin_through_vertex < @shortest_distance_to_origin
      @shortest_distance_to_origin = shortest_distance_to_origin_through_vertex
      @shortest_connections_to_origin = [ vertex ]
    end
  end
end

# added the following for auto_test by ashbb

$test0 =<<EOS
@e = 'G'
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
@e = 'H'
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
@e = 'D'
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
@e = 'G'
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
  find_redundant_resistors(@circuits, @e).collect{|a, b,| a + b}
end