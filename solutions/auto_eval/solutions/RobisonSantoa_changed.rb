#!/usr/bin/ruby -w

=begin
  AUTHOR: Robison ER Santos
  EMAIL: rwrsantos@gmail.com
  COUNTRY: Brazil


  Short Circuit - Redundant Paths
  
  This is a solution for the Ruby Programming Challenge For Newbies #3.
  
  This solution takes a circuit description in array format and creates a
  directed graph. In this directed graph its possible to get the weight
  of a path (resistance) and the node father of a given node.
  
  The circuit description should follow the pattern:
  
  [father_node, son_node, path_weight]
  
  e.g.
  [
   [ :A, :B, 50 ],
   [ :A, :D, 150],
   [ :B, :C, 250],
   [ :B, :E, 250],
   [ :C, :E, 350],
   [ :D, :C, 50 ],
   [ :C, :F, 100],
   [ :D, :F, 400],
   [ :E, :G, 200],
   [ :F, :G, 100],
  ]
  
  for the circuit: 
 
           50           150
    [B]----------[A]----------[D]
     |\                       /|
     | \_________   _________/ |
     |    250    \ /   50      |
 250 |           [C]           | 400
     |  ________/   \________  |
     | /  350           100  \ | 
     |/                       \|
    [E]----------[G]----------[F]
          200           100 
          
  It assumes the previous node as father and the next node as son in the
  direction of the last node - in this case, the node 'G'.
  
  In order to find the minimum path - short path - between the first node and
  the last node in the circuit, the solution tries to follow the path from the
  last node to the first node, always thru the vertex with least weight.
  
  This path is stored into a variable, following the same pattern as asked for
  the circuit descriton: [[father_node, son_node, path_weight]...]. When the 
  first node is reached, then the computation ends and the solution is holded.
  
  To get the redundant path, all we have to do now is to remove the minimum path
  from the circuit. What remains is the answer.
  
  For the given circuit, the minimum path is:
  [
    [:A, :D, 150],
    [:D, :C, 50 ],
    [:C, :F, 100],
    [:F, :G, 100]
  ]
  
  And the redundant path is:
  [
   [:A, :B, 50 ],
   [:B, :C, 250],
   [:B, :E, 250],
   [:C, :E, 350],
   [:D, :F, 400],
   [:E, :G, 200],
  ]
  
  For simplicity, it was created a simple module with two classes: DirectedGraph,
  for a better representation of the circuit, and Circuit, which can easily solve
  the redundant path problem, given the graph description, the first node and the
  last node.
  
  Also, to keep simplicity, it wasn't implemented command line parameters.
=end           

module ShortCircuit
  INF = 10**10
  
  # This class takes a circuit array representation and transforms it in a 
  # directed graph representation.
  class DirectedGraph
    def initialize(graph_array)
      @weights = Hash.new{|k,v| k[v] = {}} # hash of hashes.
      @fathers = Hash.new{|k,v| k[v] = []} # hash of arrays.
      
      # grab weights(u,v)
      # grab fathers(u)
      graph_array.each do |array| 
        @weights[array[0]][array[1]] = array[2] # create the matrix of weights
        @fathers[array[1]] << array[0]          # create the matrix of fathers
      end
    end
    
    # Returns the fathers of an node as an array
    def fathers(node)
      @fathers[node]
    end
    
    # Returns the weight of a given vertex [u,v]
    def weight(u,v)
      @weights[u][v]
    end
  end

  # This class can solve redundant path by calculating the minimum path of a 
  # directed graph, then removing it from the graph array representation.
  class Circuit
    def self.solve_redundant_path(graph,first, last)
      solution = [] # minimum path solution
      dgraph = ShortCircuit::DirectedGraph.new(graph) # directed graph
      
      look = last # current node
      alt = nil   # auxiliar variable             
      
      # If the first node was not reached yet, keep looking
      while look != first
        min_weight = ShortCircuit::INF # Now, the minimum weight is infinit
        
        # For each father node of the current node,
        # get the weight of their vertex and, if it is the least one, store it.
        dgraph.fathers(look).each do |n|
         n_weight = dgraph.weight(n,look)
         min_weight, alt = n_weight, n if n_weight && min_weight > n_weight 
        end
        
        # Store the minimum path
        solution.unshift [alt,look,min_weight]
        # Get the next node
        look = alt  
      end
      # Remove the minimum path form yhe graph description and return the 
      # redundant path.
      graph.delete_if {|path| solution.include? path}
    end
  end
end

################# Test ###########################
=begin
circuit = [
   [ :A, :B, 50 ],
   [ :A, :D, 150],
   [ :B, :C, 250],
   [ :B, :E, 250],
   [ :C, :E, 350],
   [ :D, :C, 50 ],
   [ :C, :F, 100],
   [ :D, :F, 400],
   [ :E, :G, 200],
   [ :F, :G, 100],
]
        
ShortCircuit::Circuit.solve_redundant_path(circuit,:A,:G).each {|path| p path}
=end

# edited the following for unit-test by ashbb

$test0 =<<EOS
@end_node = 'G'
@circuits = [
  [:A, :B, 50],
  [:A, :D, 150],
  [:B, :C, 250],
  [:D, :C, 50],
  [:B, :E, 250],
  [:D, :F, 400],
  [:C, :F, 100],
  [:C, :E, 350],
  [:F, :G, 100],
  [:E, :G, 200]
]
EOS

$test1 =<<EOS
@end_node = 'H'
@circuits = [
   [ :A, :B, 50],
   [ :A, :D, 150],
   [ :B, :C, 250],
   [ :B, :E, 250],
   [ :C, :E, 350],
   [ :C, :D, 50],
   [ :C, :F, 100],
   [ :E, :H, 200],
   [ :F, :H, 100],
   [ :D, :G, 350],
   [ :G, :F, 50],
   [ :C, :G, 30]
]
EOS

$test2 =<<EOS
@end_node = 'D'
@circuits = [
   [ :A, :B, 10],
   [ :A, :C, 100],
   [ :A, :D, 100],
   [ :B, :C, 10],
   [ :B, :D, 100],
   [ :C, :D, 10]
]
EOS

$test3 =<<EOS
@end_node = 'G'
@circuits = [
   [ :A, :B, 10],
   [ :A, :C, 100],
   [ :A, :D, 100],
   [ :B, :C, 10],
   [ :B, :D, 100],
   [ :C, :D, 10],
   [ :B, :E, 10],
   [ :C, :F, 10],
   [ :D, :G, 10]
]
EOS

def bridge_method test
  eval test
  ShortCircuit::Circuit.solve_redundant_path(@circuits,:A,@end_node.to_sym).
    collect{|a, b,| a.to_s + b.to_s}
end

