class Circuit

  def initialize(resistors)
    @resistors = resistors
    @final_node = 0

    @resistors.each do |(source, destination, resistance)|
      @final_node = [@final_node, source, destination].max
    end

    @circuit = Array.new(@final_node+1){Array.new(@final_node+1)}

    @resistors.each do |(source, destination, resistance)|
      @circuit[source][destination] = resistance
      @circuit[destination][source] = resistance
    end
  end

  def shortest_path(destination = nil, path = nil, resistance = 0)
    if path
      if path.last == destination
        [resistance, path]
      else
        @circuit[path.last].to_enum(:each_with_index).map {|x, i| 
          x && !path.include?(i) && shortest_path(destination, path.dup << i, resistance+x) || nil
        }.compact.sort.first
      end
    else
      shortest_path(@final_node, [0])
    end
  end

  def unused_resistors
    unused = @resistors.dup
    (0...(path = shortest_path[1]).size-1).each do |i| 
      unused.delete([path[i], path[i+1], @circuit[path[i]][path[i+1]]])
      unused.delete([path[i+1], path[i], @circuit[path[i+1]][path[i]]])
    end
    unused
  end
  
  def unused_resistors_with_alpha_labels
    unused_resistors.map do |(source, destination, resistance)|
      [(65+source).chr, (65+destination).chr, resistance]
    end
  end
  
end

# edited the following for unit-test by ashbb

$test0 =<<EOS
A = 0; B = 1; C = 2; D = 3; E = 4; F = 5; G = 6;
test = Circuit.new([
   [ A, B, 50],
   [ A, D, 150],
   [ B, C, 250],
   [ B, E, 250],
   [ C, E, 350],
   [ C, D, 50],
   [ C, F, 100],
   [ D, F, 400],
   [ E, G, 200],
   [ F, G, 100]
])
EOS

$test1 =<<EOS
A = 0; B = 1; C = 2; D = 3; E = 4; F = 5; G = 6; H = 7;
test = Circuit.new([
   [ A, B, 50],
   [ A, D, 150],
   [ B, C, 250],
   [ B, E, 250],
   [ C, E, 350],
   [ C, D, 50],
   [ C, F, 100],
   #[ D, F, 400],
   [ E, H, 200],
   [ F, H, 100],
   [ D, G, 350],
   [ G, F, 50],
   [ C, G, 30]
])
EOS

$test2 =<<EOS
A = 0; B = 1; C = 2; D = 3; 
test = Circuit.new([
   [ A, B, 10],
   [ A, C, 100],
   [ A, D, 100],
   [ B, C, 10],
   [ B, D, 100],
   [ C, D, 10]
])
EOS

$test3 =<<EOS
A = 0; B = 1; C = 2; D = 3; E = 4; F = 5; G = 6;
test = Circuit.new([
   [ A, B, 10],
   [ A, C, 100],
   [ A, D, 100],
   [ B, C, 10],
   [ B, D, 100],
   [ C, D, 10],
   [ B, E, 10],
   [ C, F, 10],
   [ D, G, 10]
])
EOS

def bridge_method test
  eval test
  p (tmp = test.unused_resistors_with_alpha_labels)
  tmp.collect{|a, b,| a + b}
end
