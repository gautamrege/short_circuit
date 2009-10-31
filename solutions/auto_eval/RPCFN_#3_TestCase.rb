require 'test/unit'

class Array
  def uniform
    self.collect do |e|
      (e[0], e[1] = e[1], e[0]) if e[0] > e[1]
      e
    end.sort
  end
end

class TestShortCircuit < Test::Unit::TestCase
  def test_example_0
    correct_a = ["AB", "BC", "BE", "DF", "CE", "EG"].uniform
    assert_equal correct_a, bridge_method($test0).uniform
  end

  def test_example_1
    correct_a = ["AB", "BC", "BE", "CE", "CF", "DG", "EH"].uniform
    assert_equal correct_a, bridge_method($test1).uniform
  end
  
  def test_example_2
    correct_a = ["AC", "AD", "BD"].uniform
    assert_equal correct_a, bridge_method($test2).uniform
  end
  
  def test_example_3
    correct_a = ["AC", "AD", "BD", "BE", "CF"].uniform
    assert_equal correct_a, bridge_method($test3).uniform
  end
end
