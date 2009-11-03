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

# edited the following for auto_check by ashbb

$test0 =<<EOS
@s = 'A'
@e = 'G'
@data = [
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
@s = 'A'
@e = 'H'
@data = [
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
@s = 'A'
@e = 'D'
@data = [
   [ 'A', 'B', 10],
   [ 'A', 'C', 100],
   [ 'A', 'D', 100],
   [ 'B', 'C', 10],
   [ 'B', 'D', 100],
   [ 'C', 'D', 10]
]
EOS

$test3 =<<EOS
@s = 'A'
@e = 'G'
@data = [
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
  gr = Graph.new(@data)
  gr.solve(@s,@e).collect{|a, b,| a + b}
end
