$test0 =<<EOS
  PATH = %w[AB AD BC DC BE DF CE CF EG GF]
  RESIST = [50, 150, 250, 50, 250, 400, 350, 100, 200, 100]
  CIRCUIT = Hash[*PATH.zip(RESIST).flatten]
  START, GOAL = 'A', 'G'
  NODES, N, L = ('A'..'G').to_a - [START], 10000, 6
EOS

$test1 =<<EOS
  PATH = %w[AB AD BC DC BE CE CF EH HF DG GF CG]
  RESIST = [50, 150, 250, 50, 250, 350, 100, 200, 100, 350, 50, 30]
  CIRCUIT = Hash[*PATH.zip(RESIST).flatten]
  START, GOAL = 'A', 'H'
  NODES, N, L = ('A'..'H').to_a - [START], 100000, 6
EOS

$test2 =<<EOS
  PATH = %w[AB AC AD BC BD CD]
  RESIST = [10, 100, 100, 10, 100, 10]
  CIRCUIT = Hash[*PATH.zip(RESIST).flatten]
  START, GOAL = 'A', 'D'
  NODES, N, L = ('A'..'D').to_a - [START], 10000, 6
EOS

$test3 =<<EOS
  PATH = %w[AB AC AD BC BD CD BE CF DG]
  RESIST = [10, 100, 100, 10, 100, 10, 10, 10, 10]
  CIRCUIT = Hash[*PATH.zip(RESIST).flatten]
  START, GOAL = 'A', 'G'
  NODES, N, L = ('A'..'G').to_a - [START], 10000, 6
EOS

def resistance path
  CIRCUIT[path] or CIRCUIT[path.reverse]
end

def random_path
  path = START.dup
  L.times{path << (node = NODES[rand NODES.size])}
  (n = path.index GOAL) ? path[0..n] : path[0...-1] + GOAL
end

def calc path
  dist = []
  (path.length - 1).times{|i| dist << resistance(path[i,2])}
  return(false) if dist.include?(nil)
  return path, dist.inject(:+)
end

def redundant path
  passed = []
  (path.length - 1).times{|i| passed << path[i,2] << path[i,2].reverse}
  PATH - passed
end

# edited the following for auto_test by ashbb
def bridge_method test
  eval test
  shortest_path, lowest_load = '', 100000
  N.times do
    path, dist = calc(random_path)
    (shortest_path, lowest_load =  path, dist) if dist and dist < lowest_load
  end
  p shortest_path, lowest_load, redundant(shortest_path) # debug
  redundant(shortest_path)
end

#bridge_method $test0
#bridge_method $test1
#bridge_method $test2
#bridge_method $test3