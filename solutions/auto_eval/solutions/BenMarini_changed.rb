require 'set'

class ClosedCircuit
  Infinity = 1/0.0

  def initialize(input, source, dest)
    @graph  = GraphParser.parse(input)
    @source = source
    @dest   = dest
  end

  # Substract the edges of the shortest path from the edges of the graph
  def redundant_edges
    redun = @graph.edge_set - edges_of_shortest_path
    
    # Return the redundant edges in the required format
    redun.sort.map {|e| [ e.vertices.sort.map {|v| v.name }, e.weight].flatten }
  end
  
  def edges_of_shortest_path
    edges_from_path( shortest_path )
  end

  # Use Dijkstra's algorithm to find the shortest path
  def shortest_path
    dist, previous = Hash.new(Infinity), {}
    dist[@source]   = 0.0
    queue          = @graph.vertex_set.dup

    until queue.empty?
      u = queue.min { |a,b| dist[a.name] <=> dist[b.name] }
      break if dist[u.name].infinite?
      queue.delete(u)

      u.each_edge do |e, v|
        alt = dist[u.name] + e.weight
        if alt < dist[v.name]
          dist[v.name] = alt
          previous[v.name] = u.name
        end
      end
    end

    path = []
    u    = @dest
    until previous[u].nil?
      path.unshift(u)
      u = previous[u]
    end

    path.unshift(@source)
  end

  def edges_from_path(path)
    edges = []
    each_pair_in_path(path) do |curr, nxt|
      edges << @graph.vertices[curr].edge_to( @graph.vertices[nxt] )
    end
    edges.to_set
  end

  # Iterate over each pair of vertices in the path
  def each_pair_in_path(path)
    path.each_with_index do |name, i|
      yield name, path[i+1] unless path[i+1].nil?
    end
  end

  class Graph
    attr_reader :vertex_set, :edge_set

    def initialize
      @vertex_set = Set.new
      @edge_set   = Set.new

      yield self if block_given?
    end

    def vertices
      @vertices ||= Hash.new { |hash, key| hash[key] = Vertex.new(key) }
    end

    def add_edge(u,v,w)
      u, v = vertices[u], vertices[v] # Create vertices
      e = Edge.new(u,v,w)             # Create the edge
      @edge_set.add(e)                # Add edge to edge set

      [u,v].each do |x|
        x.edges.add(e)                # Add edge to both vertex
        @vertex_set.add(x)            # Add vertex to vertex set
      end
    end
  end

  class Vertex < Struct.new(:name)
    def edges
      @edges ||= Set.new
    end

    def each_edge
      edges.each do |e|
        other = e.vertices.find { |v| v != self }
        yield e, other
      end
    end

    def edge_to(other)
      edges.find { |e| e.vertices.include?(other) }
    end

    def <=>(other)
      name <=> other.name
    end
  end

  class Edge
    attr_reader :vertices, :weight
    def initialize(u,v,w)
      @vertices = Set[u,v]
      @weight   = w.to_i
    end

    def name
      vertices.sort.map { |v| v.name }.join
    end

    def <=>(other)
      name <=> other.name
    end
  end

  class GraphParser
    def self.parse(input)
      Graph.new do |g|
        input.each_line { |l| g.add_edge(*l.split) }
      end
    end
  end
end


# edited the following for unit-test by ashbb

$test0 =<<EOS
@s, @e = 'A', 'G'
@data =<<EOD
A B 50
A D 150
B C 250
B E 250
C E 350
C D 50
C F 100
D F 400
E G 200
F G 100
EOD
EOS

$test1 =<<EOS
@s, @e = 'A', 'H'
@data =<<EOD
A B 50
A D 150
B C 250
B E 250
C E 350
C D 50
C F 100
E H 200
F H 100
D G 350
G F 50
C G 30
EOD
EOS

$test2 =<<EOS
@s, @e = 'A', 'D'
@data =<<EOD
A B 10
A C 100
A D 100
B C 10
B D 100
C D 10
EOD
EOS

$test3 =<<EOS
@s, @e = 'A', 'G'
@data =<<EOD
A B 10
A C 100
A D 100
B C 10
B D 100
C D 10
B E 10
C F 10
D G 10
EOD
EOS

def bridge_method test
  eval test
  ClosedCircuit.new(@data, @s, @e).redundant_edges.collect{|a, b,| a + b}
end


=begin

# Prove that it works
if $0 == __FILE__
  require "test/unit"
  class TestShortCircuit < Test::Unit::TestCase
    def test_short_circuit
      expected_result = [
        [ 'A', 'B', 50 ],
        [ 'B', 'C', 250],
        [ 'B', 'E', 250],
        [ 'C', 'E', 350],
        [ 'D', 'F', 400],
        [ 'E', 'G', 200],
      ]

      assert_equal expected_result, ClosedCircuit.new(DATA.read, "A", "G").redundant_edges
    end
  end
end

__END__
A B 50
A D 150
B C 250
B E 250
C E 350
C D 50
C F 100
D F 400
E G 200
F G 100
=end
