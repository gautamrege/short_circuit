# Antonio's Shortest Path program using Dijkstra's algorithm.
# Written for Gautam Rege's 'Short Circut (#3)' quiz on the RubyLearning Blog.
# Use of program from command line is as follows...
#
# => ruby short_circut.rb (text_file.txt) (starting_node) (ending_node)
#
# The text file (included) must contain one 'array of array's' in the following format.
# "[['A', 'B', 250], ...]" where the strings are nodes surrounding a resistor value (the integer).
# The 'starting_node' determines which node to start the route checking from.
# The 'ending_node' determines which node is the destination.
#
# If no starting_node is specified, the check will begin from the first node in the array.
# If no ending_node is specified, the check will simply end once all nodes have been visited
# returning the redundant paths for the last one checked (the furthest away from the start).
#
# There is no support for multiple shortest paths in this version.

require 'solutions/node'   # edited for auto_check by ashbb
require 'solutions/path'   # edited for auto_check by ashbb
require 'pp'

# The class which runs everything. Create a new instance and pass in the initial
# 'array of array's' of data, in the given text format.

class Controller
  
  def initialize(input)
    #@ary = File.open(input) {|f| eval(f.read)}    # edited for auto_check by  ashbb
    @ary = input
    @nodes = node_load(@ary)
    @paths = path_load(@ary)
  end
  
  # The method which outputs the final redundant paths in array form.
  def find_redundant_paths(start, finish=nil)
    final_array = move(start, finish).to_a
    @ary - final_array
  end
  
  # The default first node to use if one was not specified.
  def first_node
    @nodes.first.to_s
  end
  
  protected
  
  # Loads the Path data from the file given.
  # Duplicates each path with the reversed Nodes to check forwards and backwards travel.
  def path_load(ary)
    new_array = []
    ary.each do |a|
      p1 = Path.new(a[0], a[1], a[2])
      p2 = Path.new(a[1], a[0], a[2])
      new_array << p1 << p2
    end
    new_array
  end
  
  #Loads the Node data from the file given.
  def node_load(a)
    n = a.flatten.uniq.delete_if {|i| i.class == Fixnum}
    @nodes = n.collect { |n| Node.new(n) }
  end
  
  # Searches the Paths to find a qualifying path and returns it.
  def path_find(from)
    @paths.find_all {|p| node_find(p.from) == from && 
                                 node_find(p.to).not_visited?}
  end
  
  # Searches the Nodes to find one based on its id and returns it.
  def node_find(s) 
    @nodes.find {|n| n.id == s}
  end
  
  # Searches the Nodes to find the next one for move() to use.
  def smallest_unvisited
    node = @nodes.find_all {|n| n.not_visited? == true}
    ns = node.sort_by {|n| n.total}
    return nil if ns.empty?
    ns.first
  end
  
  private

  # The driving force behind the algorithm. Details inside.
  def move(start, finish)
    # Find the node to use. Works with a Node's id or a Node itself.
    current = node_find(start.to_s)
    # Make the value 0 if it is Infinity
    current.total = 0 if current.total == 1.0/0
    # Find the appropriate paths to move. Will be an array.
    paths = path_find(current)
    # Check if the new movement total will be higher than the previous. 
    # If so, change the node's total and route values.
    paths.each do |p|
      check = p.value + current.total
      if node_find(p.to).total > check || 
         node_find(p.to).total == 1.0/0
        # Change the total value.
        node_find(p.to).total = check
        # Change the new node's route to the current's one and append the new path to it.
        node_find(p.to).route = current.route + [p]
      end
    end
    # Mark the current node as visited, never to be checked again.
    current.visited!
    # Find the next node to use. Will be the 'closest', unvisited node to the start.
    next_up = smallest_unvisited
    # Keep moving through until there are no more nodes to check (all visited)
    #  or until the specified ending node is reached.
    if next_up.nil? || current.to_s == finish
      # When the looping is done, return the final node containing the route taken.
      return current
    else
      # Do the next move
      move(next_up, finish)
    end
  end 
  
end

=begin
### Program Begins ###

if __FILE__ == $0

  a = Controller.new(ARGV.shift)

  begin
    case ARGV.size
    when 0
      pp a.find_redundant_paths(a.first_node)
    when 1..2
      pp a.find_redundant_paths(*ARGV)
    else
      raise
    end
  rescue
    puts <<-EOF
Useage:
  => ruby short_circut.rb (text_file.txt) (starting_node) (ending_node)

  The 'text_file' must contain one 'array of array's' in the following format...
  => "[['A', 'B', 250], ...]" 
  The strings are nodes which surround a resistor value (the integer).

  The 'starting_node' determines which node to start the route checking from.
  The 'ending_node' determines which node is the destination.
  
  If no starting_node is specified, the check will begin from the first node in the array.
  If no ending_node is specified ,the check will simply end once all nodes have been visited,
  returning the redundant paths for the last one checked (the furthest away from the start).
EOF
  end

end
=end

# edited the following for auto_test by ashbb
$test0 =<<EOS
@end_node = 'G'
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
=begin
@circuits = [
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
=end
EOS

$test1 =<<EOS
@end_node = 'H'
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
@end_node = 'D'
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
@end_node = 'G'
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
  a = Controller.new(@circuits)
  a.find_redundant_paths('A', @end_node).collect{|a, b,| a + b}
end
