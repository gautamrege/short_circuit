# auto_check.rb

Dir.glob("./solutions/*.rb").each do |file|
  name = File.basename(file, '.rb')
  next if name == name.downcase
  
  open 'code.rb', 'w' do |out|
    out << "require 'RPCFN_#3_TestCase'\n\n"
    out << IO.read(file)
  end

  fname = "./results/#{name}.txt"
  open(fname, 'w'){|f| f << "***** #{name} *****\n\n"}
  eval "`ruby code.rb >> #{fname}`"
end

Result = Struct.new :name, :score
results = []
Dir.glob("./results/*.txt").each do |file|
  results << Result.new(File.basename(file, '.txt'), 
    IO.readlines(file).last.split(',').collect{|e| e.split.first})
end

results = results.sort_by{|e| e.score[2].to_i}

format = "%25s: %7d %12d %10d %8d %7d"
puts format.gsub('d', 's') % %w[name tests assertions failures errors skips]
results.each{|r| puts format % [r.name, r.score].flatten}



  