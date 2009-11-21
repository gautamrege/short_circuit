# The Nodes are the labeled points between the resistors.
# Each one has an id, total resistance value, visited flag and a route.
# The route is the path taken to get to that node from the start.

class Node 
  
  attr_accessor :total, :visited, :route
  attr_reader :id
  
  def initialize(id, total=1.0/0)
    @id = id
    @total = total
    @not_visited = true
    @route = []
  end
  
  def not_visited?
    @not_visited
  end
  
  def visited!
    @not_visited = false
  end
  
  def to_s
    self.id
  end
  
  def to_a
    ary = []
    @route.each {|p| ary << p.to_a}
    ary
  end
  
end