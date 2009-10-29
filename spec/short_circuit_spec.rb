require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'short_circuit'))

describe 'Short Circuit' do
    before do
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
        
    end

    it "should get shortest path, lowest resistance and redundant resisters from A to G" do
        # circuit is default Hash name for each test.
        run = ShortCircuit.new(@circuit, 'A', 'G') 
        run.get_shortest_path [], 'A', 0
        run.get_redundant_resistors

        #run.shortest_path.should == [ 'A', 'D', 'C', 'F', 'G' ]
        #run.lowest_load.should == 400
        run.redundant_resistors.should == [["A", "B", 50], ["B", "C", 250],
					   ["B", "E", 250], ["C", "E", 350],
					   ["D", "F", 400], ["E", "G", 200]]

    end

    it "should get shortest path, lowest resistance and redundant resisters from B to F" do
        # circuit is default Hash name for each test.
        run = ShortCircuit.new(@circuit, 'B', 'F') 
        run.get_shortest_path [], 'B', 0
        run.get_redundant_resistors

        #run.shortest_path.should == [ 'B', 'A', 'D', 'C', 'F' ]
        #run.lowest_load.should == 350
        run.redundant_resistors.should ==  [["B", "C", 250], ["B", "E", 250], 
					    ["C", "E", 350], ["D", "F", 400], 
					    ["E", "G", 200], ["F", "G", 100]]

    end

    it "should get shortest path, lowest resistance and redundant resisters from E to A" do
        # circuit is default Hash name for each test.
        run = ShortCircuit.new(@circuit, 'E', 'A') 
        run.get_shortest_path [], 'E', 0
        run.get_redundant_resistors

        #run.shortest_path.should == [ 'E', 'B', 'A']
        #run.lowest_load.should == 300
        run.redundant_resistors.should == [["A", "D", 150], ["B", "C", 250], 
					   ["C", "D", 50], ["C", "E", 350], 
					   ["C", "F", 100], ["D", "F", 400], 
					   ["E", "G", 200], ["F", "G", 100]]

    end

end
 
