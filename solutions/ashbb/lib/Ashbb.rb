PATH = %w[AB AD BC DC BE DF CE CF EG GF]
RESIST = [50, 150, 250, 50, 250, 400, 350, 100, 200, 100]
CIRCUIT = Hash[*PATH.zip(RESIST).flatten]
START, GOAL = 'A', 'G'
NODES, N, L = ('A'..'G').to_a - [START], 10000, 6

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

shortest_path, lowest_load = '', 10000
N.times do
  path, dist = calc(random_path)
  (shortest_path, lowest_load =  path, dist) if dist and dist < lowest_load
end

p shortest_path, lowest_load, redundant(shortest_path)
