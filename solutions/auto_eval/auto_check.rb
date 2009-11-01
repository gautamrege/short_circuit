# auto_check.rb

Temporary_Program = 'code.rb'
Dir.glob("./solutions/*.rb").each do |file|
  name, = File.basename(file).split('_')
  next if name == name.downcase
  
  open Temporary_Program, 'w' do |out|
    out << "require 'RPCFN_#3_TestCase'\n\n"
    out << IO.read(file)
  end

  Results_Directory = 'results'
  Dir.mkdir Results_Directory unless File::directory? Results_Directory

  fname = "./results/#{name}.txt"
  open(fname, 'w'){|f| f << "***** #{name} *****\n\n"}
  eval "`ruby #{Temporary_Program} >> #{fname}`"
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
results.each{|r| puts format % [r.name, r.score, 0].flatten}

File.delete Temporary_Program if File.exists? Temporary_Program 

  
