# Ruby Programming Challenge For Newbies: Short Circuit (#3)
#
#
#Author: Sam Johnson
#Date: November 20, 2009
#email: samuel.johnson@gmail.com

def find_paths(node,path_array)
    
    prior_node = path_array[path_array.length] unless path_array.length == 0
        
    path_array.push(node) # add the current node to the path
    
    if( node[1] == 'G')
      @Paths[0].push( Array.new(path_array) )  # Save the Path
      @Paths[1].push( path_array.inject(0){|sum,x| sum+x[2]} ) # Save the Path cost
    else # find a node that is connected, and hasn't been used yet, then call find_paths again
      
	   	#If this node-end hasn't been visited twice, find one connected to it: Left-Side
		if path_array.flatten.select{ |n| n == node[0] }.length < 2
	      	@CIRCUIT.select { |n| (n[0] == node[0] || n[1] == node[0]) && path_array.index(n) == nil }.
	      		each{|n| find_paths(n,Array.new(path_array))}
	  	end
	  	
	  	#If this node-end hasn't been visited twice, find one connected to it: Right-Side
	  	if path_array.flatten.select{ |n| n == node[1] }.length < 2
	  		 @CIRCUIT.select{ |n| (n[0] == node[1] || n[1] == node[1]) && path_array.index(n) == nil }.
	      		each{|n| find_paths(n,Array.new(path_array))}
	  	end	
	
    end
end

def node_to_s(node)
  "\[ \'#{node[0]}\', \'#{node[1]}\', #{node[2]}\],"
end

@CIRCUIT = [
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

@Paths = Array.new()
@Paths[0] = Array.new() # For the paths
@Paths[1] = Array.new() # For the costs

@CIRCUIT.select { |n| n[0] == 'A'}.each{ |n| find_paths(n, Array.new() ) }

@Paths[1].each_with_index do |cost,index|
  if cost == @Paths[1].min
#    puts "Min Cost Path [#{cost}]:"
#    puts "\["
#    @Paths[0][index].each{ |p| puts "  #{node_to_s(p)}"}
#    puts "\]"
    
    puts "Redundant Paths: "
    puts "\["
    @CIRCUIT.each{ |node| puts "  #{node_to_s(node)}" if @Paths[0][index].index(node) == nil}
    puts "\]"
  end
end