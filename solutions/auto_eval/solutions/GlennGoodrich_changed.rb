#!/usr/bin/env ruby

class CircuitSegment
  attr_accessor :startNode, :endNode, :ohmage
  def initialize(startNode, endNode, ohmage)
    @startNode=startNode
    @endNode=endNode
    @ohmage=ohmage
  end
end

class Circuit
  attr_accessor :segments, :start, :end
  def initialize(start,cEnd)
    @start = start
    @end = cEnd
    @segments=[]
  end
  def addSegment(segment)    
    @segments.push(segment) unless @segments.include?(segment)
  end
end

class Tracer 
  attr_accessor :circuit
  def initialize(circuit)
    @circuit=circuit
  end
  
  # Clear our possibleRoutes array and start findRoutes
  def findPossibleRoutes
    @possibleRoutes=[]
    currNode=circuit.start
    @possibleRoutes.push([currNode])
    findRoutes
  end
  
  # Find the routes available based on the current
  # value for possibleRoutes.
  # Basically, this goes through all the possibleRoutes
  # that have been built so far, takes the last letter
  # and selects the segments that have that letter as a
  # startNode.  
  def findRoutes
    @possibleRoutes.each do |a|
      currNode  = a.last
      next if (currNode==@circuit.end)  
      currentNodes = @circuit.segments.select { |c| c.startNode==currNode}
      currentRoutes = @possibleRoutes.select { |r| r.last==currNode}
      next if currentRoutes.empty?
	      
      for i in 1..currentNodes.length
	newArray=currentRoutes[0].dup
	for i in 1..currentNodes.length-1
	  newArray.push(currentNodes[i].endNode)
	end
	@possibleRoutes.push(newArray) unless @possibleRoutes.include?(newArray)
      end
      currentRoutes[0].push(currentNodes[0].endNode)
      findRoutes
    end   
  end
  
  # The workhorse.  For each possibleRoute, calculate the ohmage
  # and pass the winning route (with the lowest ohmage) to be
  # printed  
  def pathOfLeastResistance
    findPossibleRoutes
    winningRoute=nil
    winningOhmage=0
    path=[]    
    @possibleRoutes.each do |rt|
      currentOhmage = calculateOhmageForRoute(rt)      
      if currentOhmage < winningOhmage or winningOhmage==0
	currentOhmage=winningOhmage
	winningRoute=rt
      end
    end     		
    printRedundant(winningRoute) unless winningRoute.nil?
  end
  
  # Calculate the ohmage for the given route
  # The route is expected to be an array of 
  # letters representing nodes.
  def calculateOhmageForRoute(rt)
    sum=0
    getNodesForRoute(rt) do |n|
      sum = sum + n.ohmage
    end  
    sum
  end
  
  # Print the route.  The passed in route is the route
  # we want to KEEP.  The redundant nodes will be derived
  # from  this route.
  def printRedundant(rt)    
    segsToKeep =[]
    getNodesForRoute(rt) do |n|
      segsToKeep.push(n)
    end    
    (@circuit.segments-segsToKeep).map do |s|
      [s.startNode, s.endNode, s.ohmage] 
    end       
  end
  # Helper method to get segments for the supplied route
  # and run the block on each segment
  def getNodesForRoute(rt,&code)
    rt.each_with_index do |node,index| 
      if node!=rt.last
	segs=@circuit.segments.select do |n|
	  n.startNode==node && n.endNode==rt[index+1]
	end	
	code.call(segs[0])
      end
    end
  end
end

=begin
def doIt
  circ= Circuit.new("A","G")
  circ.addSegment(CircuitSegment.new("A","B",50))
  circ.addSegment(CircuitSegment.new("A","D",150))
  circ.addSegment(CircuitSegment.new("B","C",250))
  circ.addSegment(CircuitSegment.new("B","E",250))
  circ.addSegment(CircuitSegment.new("C","E",350))
  circ.addSegment(CircuitSegment.new("D","C",50))
  circ.addSegment(CircuitSegment.new("C","F",100))
  circ.addSegment(CircuitSegment.new("D","F",400))
  circ.addSegment(CircuitSegment.new("E","G",200))
  circ.addSegment(CircuitSegment.new("F","G",100))
  tr=Tracer.new(circ)
  tr.pathOfLeastResistance
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
   [ 'D', 'C', 50],
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
  circ= Circuit.new("A",@end_node)
  @circuits.each do |a, b, c|
    circ.addSegment(CircuitSegment.new(a, b, c))
  end
  tr=Tracer.new(circ)
  tr.pathOfLeastResistance.collect{|a, b,| a + b}
end
