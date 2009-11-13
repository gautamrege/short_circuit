require 'test/unit'
require 'electricity'
  
class ElectricityTest < Test::Unit::TestCase
  def setup
    all_edges = [
       [ :a, :b, 50],
       [ :a, :d, 150],
       [ :b, :c, 250],
       [ :b, :e, 250],
       [ :c, :e, 350],
       [ :c, :d, 50],
       [ :c, :f, 100],
       [ :d, :f, 400],
       [ :e, :g, 200],
       [ :f, :g, 100]
    ]
    
    @electricity = Electricity.new(all_edges, :a, :g)
  end
  
  def test_should_find_path_of_least_resistance
    assert_equal(
      [
        [:a, :d, 150],
        [:c, :d, 50],
        [:c, :f, 100],
        [:f, :g, 100],
      ],
      @electricity.find_path_of_least_resistance
    )
  end
  
  def test_should_find_unused_edges
    assert_equal(
      [
        [ :a, :b, 50],
        [ :b, :c, 250],
        [ :b, :e, 250],
        [ :c, :e, 350],
        [ :d, :f, 400],
        [ :e, :g, 200],
      ],
      @electricity.find_unused_edges
    )
  end
  
end