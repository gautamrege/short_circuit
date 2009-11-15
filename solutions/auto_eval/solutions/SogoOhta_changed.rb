=begin    # commented out for auto_check by ashbb
paths = 
  [
    {:from => "A", :to => "B", :len => 50},
    {:from => "A", :to => "D", :len => 150},
    {:from => "B", :to => "C", :len => 250},
    {:from => "B", :to => "E", :len => 250},
    {:from => "C", :to => "E", :len => 350},
    {:from => "D", :to => "C", :len => 50},
    {:from => "C", :to => "F", :len => 100},
    {:from => "D", :to => "F", :len => 400},
    {:from => "E", :to => "G", :len => 200},
    {:from => "F", :to => "G", :len => 100},
]
done_node = "A"
min_paths = []
=end

def search_min_path(available_paths, done_node, min_len=0, searched_path=[])
  available_paths -= searched_path

  done_undone_path = available_paths.select{|path| path[:from] == done_node}.min{|a,b| a[:len] <=> b[:len]}
  return searched_path.pop unless done_undone_path

  undone_node = done_undone_path[:to]
  return done_undone_path if undone_node == "G" 

  undone_undone_next_path = available_paths.select{|path| path[:from] == undone_node}.min{|a,b| a[:len] <=> b[:len]}
  undone_next_node = undone_undone_next_path[:to]

  done_undone_next_path = available_paths.detect{|path| path[:from] == done_node && path[:to] == undone_next_node}

  if done_undone_next_path && done_undone_next_path[:len] <= done_undone_path[:len]  + undone_undone_next_path[:len]
    return done_undone_next_path
  else
    if done_undone_path[:len]  + undone_undone_next_path[:len] < min_len || min_len == 0
      min_len = done_undone_path[:len] + undone_undone_next_path[:len] 
      searched_path.push done_undone_path
    else    
      searched_path.unshift done_undone_path
    end
    min_path = search_min_path(available_paths, done_node, min_len, searched_path)
  end 

  min_path 
end

=begin
while(done_node != "G")
  path = search_min_path(paths, done_node)
  done_node = path[:to]
  min_paths.push path
end

require 'pp'   
pp paths - min_paths
=end


# edited the following for unit-test by ashbb

$test0 =<<EOS
$out = ''
@endposition = 'G'
@circuits = [
{:from => "A", :to => "B", :len => 50},
{:from => "A", :to => "D", :len => 150},
{:from => "B", :to => "C", :len => 250},
{:from => "D", :to => "C", :len => 50},
{:from => "B", :to => "E", :len => 250},
{:from => "D", :to => "F", :len => 400},
{:from => "C", :to => "F", :len => 100},
{:from => "C", :to => "E", :len => 350},
{:from => "F", :to => "G", :len => 100},
{:from => "E", :to => "G", :len => 200}
]
EOS

$test1 =<<EOS
$out = ''
@endposition = 'H'
@circuits = [
{:from => "A", :to => "B", :len => 50},
{:from => "A", :to => "D", :len => 150},
{:from => "B", :to => "C", :len => 250},
{:from => "B", :to => "E", :len => 250},
{:from => "C", :to => "E", :len => 350},
{:from => "C", :to => "D", :len => 50},
{:from => "C", :to => "F", :len => 100},
{:from => "E", :to => "H", :len => 200},
{:from => "F", :to => "H", :len => 100},
{:from => "D", :to => "G", :len => 350},
{:from => "G", :to => "F", :len => 50},
{:from => "C", :to => "G", :len => 30}
]
EOS

$test2 =<<EOS
$out = ''
@endposition = 'D'
@circuits = [
{:from => "A", :to => "B", :len => 10},
{:from => "A", :to => "C", :len => 100},
{:from => "A", :to => "D", :len => 100},
{:from => "B", :to => "C", :len => 10},
{:from => "B", :to => "D", :len => 100},
{:from => "C", :to => "D", :len => 10}
]
EOS

$test3 =<<EOS
$out = ''
@endposition = 'G'
@circuits = [
{:from => "A", :to => "B", :len => 10},
{:from => "A", :to => "C", :len => 100},
{:from => "A", :to => "D", :len => 100},
{:from => "B", :to => "C", :len => 10},
{:from => "B", :to => "D", :len => 100},
{:from => "C", :to => "D", :len => 10},
{:from => "B", :to => "E", :len => 10},
{:from => "C", :to => "F", :len => 10},
{:from => "D", :to => "G", :len => 10}
]
EOS


def bridge_method test
  eval test
  done_node = "A"
  min_paths = []
  while(done_node != @endposition)
    path = search_min_path(@circuits, done_node)
    done_node = path[:to]
    min_paths.push path
  end
  (@circuits - min_paths).collect{|e| e[:from] + e[:to]}
end

