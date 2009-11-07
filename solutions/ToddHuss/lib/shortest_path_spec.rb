require File.dirname(__FILE__) + '/spec_helper.rb'

describe ShortestPath do
  include ShortestPath
  
  describe "when testing with the RPCFN 3 example graph" do
    before(:each) do
      @rpcfn_graph = [
        ['A', 'B', 50], ['A', 'D', 150], ['B', 'C', 250], ['B', 'E', 250], ['C', 'E', 350],
        ['C', 'D', 50], ['C', 'F', 100], ['D', 'F', 400], ['E', 'G', 200], ['F', 'G', 100]
      ]
    end
    
    it "should find the unused paths" do
      unused_paths('A', 'G', @rpcfn_graph).should eql([
        ["A", "B", 50], ["B", "C", 250], ["B", "E", 250], ["C", "E", 350], ["D", "F", 400], 
        ["E", "G", 200]
      ])
    end

    it "should find the shortest path" do
      path = shortest_path('A', 'G', @rpcfn_graph)
      path.should eql([["A", "D", 150], ["C", "D", 50], ["C", "F", 100], ["F", "G", 100]])
      path.distance.should eql(400)
    end
  end

  # This is where my TDD process started, trying to solve the simplest case and building on it
  it "should return an empty path if we can't complete the path" do
    shortest_path('A', 'X', [[ 'A', 'B', 50]]).empty?.should be_true
  end
  
  it "should find the shortest path with only 2 nodes and 1 edge" do
    graph = [[ 'A', 'B', 50]]
    shortest_path('A', 'B', graph).should eql(graph)
  end
  
  it "should find the shortest path with multiple legs strung together" do
    graph = [[ 'A', 'B', 50], ['B', 'C', 50], ['C', 'D', 50]]
    path = shortest_path('A', 'D', graph)
    path.should eql(graph)
    path.distance.should eql(150)
  end
  
  it "should find the shortest path with 2 nodes and 2 edges" do
    short = [['A', 'B', 40]]
    long = [['A', 'B', 50]]
    path = shortest_path('A', 'B', short + long)
    path.should eql(short)
    path.distance.should eql(40)
  end
  
  it "should choose a shortest path when 2 paths are equal" do
    path_a = [['A', 'B', 10], ['B', 'D', 20]]
    path_b = [['A', 'C', 20], ['C', 'D', 10]]
    path = shortest_path('A', 'D', path_a + path_b)
    path.should eql(path_a)
    path.distance.should eql(30)
  end

  it "should find the shortest path with multiple legs, multiple routes, and a dead end" do
    short = [['A', 'D', 20], ['D', 'E', 5]] # 25
    long = [[ 'A', 'B', 10], ['B', 'C', 10], ['B', 'Z', 1], ['C', 'E', 10]] # 30
    path = shortest_path('A', 'E', short + long)
    path.should eql(short)
    path.distance.should eql(25)
  end

end
