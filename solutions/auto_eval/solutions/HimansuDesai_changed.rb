## main.rb
require 'solutions/network'  # edited for auto_check by ashbb
#require 'test/unit'

# Normal array to_string printout is hard to read.  Put some spaces and add
# leading/trailing square brackets '[' ']' to make the array printout a bit prettier
class Array
    def to_s
        str = "["
        self.each { |e| str << " #{e}"}
        str << " ]"
    end
end

=begin
test_array = []
test_array << [  ["A B 50", "A D 150", "B C 250", "B E 250", "C E 350", "F G 100", "D F 400", "F C 100", "E G 200", "C D 50"],
                                '[ A B 50 ] [ B C 250 ] [ B E 250 ] [ C E 350 ] [ D F 400 ] [ E G 200 ] ' ]
test_array << [ ["A B 1", "A D 3", "B C 3", "B E 1", "E C 1", "E G 4", "F G 1", "F D 3", "F C 1", "C D 3"],
                        '[ A D 3 ] [ B C 3 ] [ E G 4 ] [ F D 3 ] [ C D 3 ]' ]
test_array << [ ["A B 2", "A C 6", "B G 7", "C G 3", "B C 3"],
                        '[ A C 6 ] [ B G 7 ]' ]
test_array << [ ["A B 3", "A C 2", "B G 3", "C G 2", "B C 1"],
                        '[ A B 3 ] [ B G 3 ] [ B C 1 ]' ]

test_array.each do | e |
    puts "For          #{e[0]}"
    puts "Expected Answer   #{e[1]}"
    puts "Actual Answer   #{Network.obsolete_segments(e[0], 'A', 'G')}\n\n"
end
=end

# edited the following for unit-test by ashbb

$test0 =<<EOS
@s, @e = 'A', 'G'
@data =<<EOD
A B 50
A D 150
B C 250
B E 250
C E 350
C D 50
C F 100
D F 400
E G 200
F G 100
EOD
EOS

$test1 =<<EOS
@s, @e = 'A', 'H'
@data =<<EOD
A B 50
A D 150
B C 250
B E 250
C E 350
C D 50
C F 100
E H 200
F H 100
D G 350
G F 50
C G 30
EOD
EOS

$test2 =<<EOS
@s, @e = 'A', 'D'
@data =<<EOD
A B 10
A C 100
A D 100
B C 10
B D 100
C D 10
EOD
EOS

$test3 =<<EOS
@s, @e = 'A', 'G'
@data =<<EOD
A B 10
A C 100
A D 100
B C 10
B D 100
C D 10
B E 10
C F 10
D G 10
EOD
EOS

def bridge_method test
  eval test
  Network.obsolete_segments(@data, @s, @e).collect{|a, b,| a.to_s + b.to_s}
end
