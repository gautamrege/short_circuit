

class ShortCircuit
    attr_accessor :lowest_load, :redundant_resistors, :shortest_path

    Infinity = 1.0 / 0 # This is the answer to the maximum resistance question.
    def initialize(circuit, source, destination)
        @circuit = circuit
        @start = source
        @end = destination
        @lowest_load = Infinity # maximum possible resistance is Infinity!
        @redundant_resistors = []
    end
    
    #
    # A recursive funtion where we do a depth-first traversal to find the 
    # shortest path. A global variable stores the shortest path and the 
    # lowest load
    #
    def get_shortest_path(traversed, node, weight)
        # if node is in the traversed list, return.
        return if traversed.include? node
    
        # push teh node as we have traversed it
        traversed.push node
        
        # iterate throught the node's hash
        @circuit[node].each do |key, value|
    
            if key == @end
                if @lowest_load > weight+value
                    @lowest_load = weight+value
                    @shortest_path = Array.new(traversed.push(key))
                    traversed.pop
                end
                # skip if we have reached the 'end node' but load is greater.
            else
                # invoke shortest_path with traversed and this node
                get_shortest_path traversed, key, weight+value
            end
        end
    
        # remove the node as we have traversed all its children
        traversed.pop
    end

    #
    # Print all redundant resistors. Pop each element out of the shortest_path 
    # global, as we dont need it anymore ;)
    #
    def get_redundant_resistors

        # Make a copy of the shortest path array
        path = @shortest_path.dup 

        # Make a copy of the hash
        circuit = @circuit.dup

        # remove the shortest path nodes from the tree
        # along with its back reference
        while (node = path.pop) # set and check for nil
            circuit[path[-1]].delete node if path[-1]
            circuit[node].delete path[-1] if path[-1]
        end

        # Actual pretty printing!
        circuit.each_pair do |key, value|
            # remove the back-references
            value.keys.each { |k| circuit[k].delete(key) if circuit.has_key?(k) }
            value.each_pair do |node, resistance|
               @redundant_resistors << [ key, node, resistance ]
            end
        end
    end

end
