# The Paths are the resistors with refrences to which Nodes surround them.

class Path
  
  attr_reader :from, :to, :value
  
  def initialize(n1, n2, value)
    @from = n1
    @to = n2
    @value = value
  end

  def to_a
    [@from, @to].sort << @value
  end
  
end