require 'test/unit'
require 'path_finder'
  
class PathFinderTest < Test::Unit::TestCase
  def setup
    all_edges = [
       [:a, :b],
       [:a, :d],
       [:b, :c],
       [:b, :e],
       [:c, :e],
       [:c, :d],
       [:c, :f],
       [:d, :f],
       [:e, :g],
       [:f, :g],
    ]
    
    @path_finder = PathFinder.new(all_edges, :a, :g)
  end
  
  def test_should_find_all_possible_paths
    all_paths = @path_finder.find_all_paths
    
    all_paths.each do |path|
      assert_equal(:g, path.last[1])
    end
  end
  
  def test_should_find_available_edges_when_no_history
    assert_equal(
      [[:a,:b],[:a,:d]], 
      @path_finder.get_next_possible_edges([], :a))
    
    assert_equal(
      [[:a,:b],[:b,:c],[:b,:e]], 
      @path_finder.get_next_possible_edges([], :b))
  end
  
  def test_should_find_available_edges_and_exclude_the_edges_in_the_history
    assert_equal(
      [[:a,:d]], 
      @path_finder.get_next_possible_edges([[:a,:b]], :a))
    
    assert_equal(
      [[:b,:c],[:c,:e],[:c,:f]], 
      @path_finder.get_next_possible_edges([[:a,:d], [:c,:d]], :c))
  end
  
end