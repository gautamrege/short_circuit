## main.rb
require 'network.rb'
#require 'test/unit'

# Normal array to_string printout is hard to read.  Put some spaces and add
# leading/trailing square brackets '[' ']' to make the array printout a bit prettier
class Array
    def to_s
        str = "["
        self.each { |e| str << " #{e}"}
        str << " ]"
    end
end

test_array = []
test_array << [  ["A B 50", "A D 150", "B C 250", "B E 250", "C E 350", "F G 100", "D F 400", "F C 100", "E G 200", "C D 50"],
                                '[ A B 50 ] [ B C 250 ] [ B E 250 ] [ C E 350 ] [ D F 400 ] [ E G 200 ] ' ]
test_array << [ ["A B 1", "A D 3", "B C 3", "B E 1", "E C 1", "E G 4", "F G 1", "F D 3", "F C 1", "C D 3"],
                        '[ A D 3 ] [ B C 3 ] [ E G 4 ] [ F D 3 ] [ C D 3 ]' ]
test_array << [ ["A B 2", "A C 6", "B G 7", "C G 3", "B C 3"],
                        '[ A C 6 ] [ B G 7 ]' ]
test_array << [ ["A B 3", "A C 2", "B G 3", "C G 2", "B C 1"],
                        '[ A B 3 ] [ B G 3 ] [ B C 1 ]' ]

test_array.each do | e |
    puts "For          #{e[0]}"
    puts "Expected Answer   #{e[1]}"
    puts "Actual Answer   #{Network.obsolete_segments(e[0], 'A', 'G')}\n\n"
end

## network.rb
# A segment is a unique entity in a network - identified by a named
# node on each end and a resistance between the two nodes
class Segment < Object
    attr_accessor :ohms, :node1, :node2

    # "other end" given one end
    def target_node(src_node)
        (self.node2 == src_node) ? self.node1 : self.node2
    end

    def initialize (nd1, nd2, res)
        self.node1 = nd1; self.node2 = nd2; self.ohms = res
    end

    # Convert to an array
    def to_a
        [self.node1.name, self.node2.name, self.ohms]
    end
end

# A unique 'named' entity in the network.  It has an array of segments
# which effectively document what other nodes are linked to this one
class Node < Object
    attr_accessor :name, :segments

    # For this node (could be any in the network), compute the shortest path
    # to 'ground'.  For this algorithm, we need to know what nodes have already
    # been visited because we don't want to "turn back".  So we stop tracing
    # when we hit 'ground' or a node that has already been visited
    def shortest_path(visited, ground)
        unless self == ground
            # really large number guaranteed to be larger than the resistance of a particular segment
            ohms = Math.exp(999)
            path = []
            # for each segment connected to this node...
            self.segments.each do |s|
                tar_node = s.target_node(self)
                unless visited.include?(tar_node)
                    visited_copy = visited.clone << self
                    # recursively ask target node to compute its shortest path
                    result = tar_node.shortest_path(visited_copy, ground)
                    # if the result path is shorter than our current shortest path then...
                    if ((result[:ohms] + s.ohms) < ohms)
                        # the new shortest resistance value = target node's shortest resistance
                        # plus the resistance of the segment connecting to that node
                        ohms = result[:ohms] + s.ohms
                        # record the shortest path also.  it is an array and we need to add the
                        # segment at the 'head' of the array
                        path = result[:path].unshift(s)
                    end
                end
            end
            # return the shortest path (segment array) and value of total resistance for that path
            {:path => path, :ohms => ohms}
        else # self == ground
            # for ground, we have nothing interesting to return - we are already at th end
            {:path => [], :ohms => 0}
        end
    end

    # add a segment to this node
    def <<(seg)
        self.segments << seg
    end

    def initialize(name)
        self.name = name
        self.segments = []
    end
end

# Utility class (probably didn't need a whole separate class just for holding one method)
# Compute the shortest path and by 'subtraction' compute the obsolete segments in the
# network.  Algorithm needs to be know the source of electricity and the end point (ground)
class Network
    def self.obsolete_segments (seg_defs, source, ground)
        nodes = {}
        segments = []
        # for each segment definition ...
        seg_defs.each do |seg_def|
            seg = seg_def.split(' ')
            # figure out the two node names for each end of the segment
            src_name = seg[0].to_sym
            tar_name = seg[1].to_sym
            # have we already seen a node with that name before - if so get it - otherwise create a new one
            src_node = (nodes[src_name] == nil) ? nodes[src_name] = Node.new(src_name) : nodes[src_name]
            tar_node = (nodes[tar_name] == nil) ? nodes[tar_name] = Node.new(tar_name) : nodes[tar_name]
            # create a new segment with the two nodes at each end and the resistance value
            seg = Segment.new(src_node, tar_node, seg[2].to_i)
            src_node << seg
            tar_node << seg
            # collect all unique segments into this variable
            segments << seg
        end

        source_node = nodes[source.to_sym]
        ground_node = nodes[ground.to_sym]
        # compute shortest path
        result = source_node.shortest_path([], ground_node)
        path = result[:path]
        # eliminate the shortest path to get to obsolete segments
        path.each {|e| segments.delete(e)}
        # convert that to array because the assignment asks for an array of arrays
        segments.collect! { |e| e.to_a}
        segments
    end
end
