# Ruby Programming Challenge For Newbies
# RPCFN: Short Circuit (#3)
# By Gautam Rege
# Solution by Valério Farias 
#
# To find the smallest path I used the dijkstra algorithm.
# My inspiration was this example: http://snippets.dzone.com/posts/show/7331
# To execute the class first load the file:
# require 'short-circuit'
# Then initialize the class: 
# gr = Graph.new([['a','b',50],['a','d',150],['b','c',250],['b','e',250],['c','e',350],['c','d',50],['c','f',100],['d','f',400],['e','g',200],['f','g',100]])
# Finally use the method solve putting the source and the target values in the parameters:
# gr.solve('a','g')
# This must return the solution:
# => [["a", "b", 50], ["b", "c", 250], ["b", "e", 250], ["c", "e", 350], ["d", "f", 400], ["e", "g", 200]]

class Graph

  attr_reader :list, :solution

  def initialize(graph)
    @graph = {}
    @nodes = Array.new
    @INFINITY = 1 << 32
    @list = graph

    graph.each do |item|
    	source = item[0]
    	target = item[1]
    	weight = item[2]

    	if @graph.has_key?(source)	 
    		@graph[source][target] = weight
    	else
    		@graph[source] = {target => weight}
    	end

    	if @graph.has_key?(target)
    		@graph[target][source] = weight
    	else
    		@graph[target] = {source => weight}
    	end

    	@nodes << source unless @nodes.include?(source)
    	@nodes << target unless @nodes.include?(target)
    end
  end

  # based of wikipedia's pseudocode: http://en.wikipedia.org/wiki/Dijkstra's_algorithm
  def dijkstra(s)
    @distance = {}
    @prev = {}

    @nodes.each do |i|
    	@distance[i] = @INFINITY
    	@prev[i] = -1
    end

    @distance[s] = 0
    node_list = @nodes.compact
    while (not node_list.empty?)
    	smallest = nil;
    	node_list.each do |min|
    		if (not smallest) or (@distance[min] and @distance[min] < @distance[smallest])
    			smallest = min
    		end
    	end

    	break if @distance[smallest] == @INFINITY

    	node_list = node_list - [smallest]
    	@graph[smallest].keys.each do |v|
    		alt = @distance[smallest] + @graph[smallest][v]
    		if (alt < @distance[v])
    			@distance[v] = alt
    			@prev[v]  = smallest
    		end
    	end
    end
  end

  def solve(s,t)
    smallest_path = []
    @solution = @list
    dijkstra(s) 

    while(@prev[t]!= -1)
    	smallest_path << [@prev[t], t, @graph[t][@prev[t]]]
    	smallest_path << [t, @prev[t], @graph[t][@prev[t]]]
    	t = @prev[t] 
    end

    # solution == list - smallest_path
    smallest_path.each{ |i| @solution = @solution - [i] }
    return @solution	
  end
end

