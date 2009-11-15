class Graph
  require 'set'
  INFINITY = 1 << 64

  # Constructor
  def initialize
    @graph = magic_hash
    # The graph // {node => { edge1 => weight, edge2 => weight}, node2 => ...
    @nodes = Set.new
  end

  

  def add_edge source, destination, weight
      @graph[source][destination] = weight

    # Begin code for non directed graph (inserts the other edge too)
      @graph[destination][source] = weight
    # End code for non directed graph (ie. deleteme if you want it directed)
      
      @nodes << source
      @nodes << destination
  end

  def dijkstra source
    @distance = {}
    @previous = {}

    @nodes.each do |i|
      @distance[i] = INFINITY
      @previous[i] = -1
    end

    @distance[source] = 0
    unsolved_vertices = @nodes.delete_if { |x| x.nil? } 
    while (unsolved_vertices.size > 0)
      current_node = nil;
      unsolved_vertices.each do |min|
        if (not current_node) or (@distance[min] and @distance[min] < @distance[current_node])
          current_node = min
        end
      end
      if (@distance[current_node] == INFINITY)
        break
      end
      unsolved_vertices = unsolved_vertices.delete current_node
      @graph[current_node].keys.each do |v|
        alternative_distance = @distance[current_node] + @graph[current_node][v]
        if (alternative_distance < @distance[v])
          @distance[v] = alternative_distance
          @previous[v]  = current_node
        end
      end
    end
  end

  # To print the full shortest route to a node

  def print_path(dest)
    if @previous[dest] != -1
      print_path @previous[dest]
    end
    print ">#{dest}"
  end

  def redundant_nodes_for source, destination
    path = [destination]
    current = destination
    arcs = Set.new
    while ![-1, source].include? current
      path << @previous[current]
      current = @previous[current]
    end

    @graph.keys.each do |node|
      @graph[node].each do |dest, weight|
        next if adjacent_in_path? path, node, dest
        arc = Set.new
        arc << node << dest
        next if arcs.include? arc
        puts "#{node} -> #{dest} : #{weight}"
        arcs << arc
      end
    end
  end

  private

  def adjacent_in_path? path, source, destination
    node = path.find_index { |x| x == source }
    dest = path.find_index { |x| x == destination }
    return false if node.nil? ||
            dest.nil? ||
            (node.succ != dest &&
            dest.succ != node)
    return true
  end

  def magic_hash
    Hash.new {|h,k| h[k] = Hash.new(&h.default_proc)}
  end

end

a = Graph.new

[
  " A, B, 50",
  " A, D, 150",
  " B, C, 250",
  " B, E, 250",
  " C, E, 350",
  " C, D, 50",
  " C, F, 100",
  " D, F, 400",
  " E, G, 200",
  " F, G, 100",
].each do |array|
    array = array.split(',')
    array.map! { |x| x.strip }
    source = array[0].strip
    destination = array[1].strip
    resistance = array[2].to_i
    a.add_edge source, destination, resistance
end

a.dijkstra 'A'
puts
a.redundant_nodes_for 'A', 'G'