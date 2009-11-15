=begin
 The solution has been generalized to support basic network structures.
 The network can be for example a circuitboard as required for this challenge,
 or a map of geographical locations, or a network of people, or a model of a molecule...

 The network consists of nodes that are associated with one another via paths.

 Any path between 2 nodes, say nodes A and B will be represented twice in the 
 network to support bi-directionality.
 It exists once as a path leading from A to B, associated with node A, and then
 as a node leading from B to A, associated with node B.
 Each path has a cost attribute which generalizes the expense associated with
 moving from the start node to the target node. The cost attribute could for eaxmple
 refer to the distance between two nodes, or, as the challenge requires, the resistance.

 A node may have any number of paths (0 to n) leading from it to link it to any number of
 target nodes (0 to n).
 The pathway traced from any node to another is referred to as a Route.
 There can be many routes linking a start and destination node.

 The network - node - path model can be useful in a large number of application
 over and above the RPCFN3 challenge.

 The solution is contained in 3 files
  1.         RPCFN3.rb - The main script (this file)
  2. RPCFN3_classes.rb - Contains all class definitions
  3.   RPCFN3_tests.rb - Tests

=end
PATH_RPCFN3 = [
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
FROM = 'A'
TO = 'G'

def get_redundant_resistors(nw)
#
# Get a unique list of path names.
# Get the list of paths in the shortest route.
# Get the difference - this is the redundant set of paths (bi-directional).
# Remove the duplicates to get the required result (see below)
#
  all_paths = (nw.path_list.collect {|p| [p.from, p.to]})
  min_paths = nw.min_cost_routes.first.path_list.collect {|p| [p.from, p.to]}
  #
  #  The difference (all_paths - min_paths) is the true list of redundant paths
  # taking into account that the network is implemented as bidirectional, so
  # that each path exists twice, once in each direction, from one node to the
  # other.
  # The reverse paths are therefore removed to arrive at the required output
  # list of redundant resistors.
  #
  redundant_resistors = (all_paths.collect {|p| p.sort.join('_')}).uniq - (min_paths.collect {|p| p.join('_')})
  redundant_resistors.collect {|r| nw.path(r).to_a}
end
def show_results(nw)
  nw.routes.each {|r| puts "Route #{r.name} cost #{r.cost} pathway #{r.nodes.collect {|n| n.name + ' '}}"}
  puts "Minimum cost = #{nw.min_cost}, shared by routes #{(nw.min_cost_routes.collect {|r| r.name}).join(',')}"
  puts "Maximum cost = #{nw.max_cost}, shared by routes #{(nw.max_cost_routes.collect {|r| r.name}).join(',')}"
  puts "Average cost = #{nw.avg_cost}"
end

require 'RPCFN3_classes'

nw = Network.new        # Create an empty network
nw.import(PATH_RPCFN3)  # Load the network using data as formated in RPCFN3
nw.get_routes(FROM, TO) # Do the work. Assembles an array of all possible
                        # routes for given start and end nodes
output = get_redundant_resistors(nw)
puts "["
output.each {|p| puts "\t[#{p.join(',')}]"}
puts "]"

#nw.import(PATHS_TO_ROME)
#nw.get_routes('Paris', 'Istanbul')
#show_results(nw)

require 'test/unit'
require 'RPCFN3_tests'