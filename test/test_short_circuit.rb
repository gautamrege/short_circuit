require 'test/unit' unless defined? $ZENTEST and $ZENTEST
require 'lib/short_circuit'


class TestShortCircuit < Test::Unit::TestCase

  def setup 
    @circuit = 
    { 
      'A' => {
        'B' => 50,
        'D' => 150
      },
      
      'B' => {
          'E' => 250,
          'A' =>50,
          'C' => 250
      },
    
      'C' => {
          'B' => 250,
          'E' => 350,
          'D' => 50,
          'F' => 100
      },
    
      'D' => {
          'A' => 150,
          'C' => 50,
          'F' => 400
      },
    
      'E' => {
          'B' => 250,
          'C' => 350,
          'G' => 200
      },
    
      'F' => {
          'G' => 100,
          'D' => 400,
          'C' => 100
    
      },
    
      'G' => {
          'E' => 200,
          'F' => 100
      }
    }
  

    @my_circuit = ShortCircuit.new(@circuit, 'A', 'G')

  end

  def test_Infinity_is_infinity
    assert_equal(1.0/0, ShortCircuit::Infinity)
  end

  def test_get_shortest_path
    @my_circuit.get_shortest_path([],  'A', 0)
    assert_equal(["A", "D", "C", "F", "G"], @my_circuit.shortest_path)
  end

  def test_get_redundant_resistors
    
    expected_redundant_resistors = [["A", "B", 50],
				   ["B", "C", 250],
				   ["B", "E", 250],
				   ["C", "E", 350],
				   ["D", "F", 400],
				   ["E", "G", 200]]
    @my_circuit.get_shortest_path [], 'A', 0
    @my_circuit.get_redundant_resistors
    assert_equal(expected_redundant_resistors, @my_circuit.redundant_resistors)
  end

  def test_lowest_load
    @my_circuit.get_shortest_path [], 'A', 0
    @my_circuit.get_redundant_resistors
    assert_equal(400, @my_circuit.lowest_load)
  end

  def test_shortest_path
    assert_equal(nil, @my_circuit.shortest_path)
  end

end

