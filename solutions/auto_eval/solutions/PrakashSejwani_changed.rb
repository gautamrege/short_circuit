class Resistor
	def reductant_resistors(a)
		# if current flows from A towards B	to C to D to F to G
		b = []
		b << a[0]
		b << a[2]	
		b << a[4]
		b << a[7]
		b << a[9] 
		ac = b.flatten
		ac1 = ac.select{|x| x.class == Fixnum}
		d = 0
		for i in 0..(ac1.length-1) 
			d += ac1[i]
		
		end
		
		# if current flows from A towards B to C to F to G
		b1 = []
		b1 << a[0] 
		b1 << a[2]
		b1 << a[6]
		b1 << a[9]
		bc = b1.flatten
		bc1 = bc.select{|x| x.class == Fixnum}
		d1 = 0
		for i in 0..(bc1.length-1) 
			d1 += bc1[i]
			
		end	

		# if current flows from A towards B to C to E to G
		b2 = []
		b2 << a[0] 
		b2 << a[2]
		b2 << a[5]
		b2 << a[8]
		cc = b2.flatten
		cc1 = cc.select{|x| x.class == Fixnum}
		d2 = 0
		for i in 0..(cc1.length-1) 
			d2 += cc1[i]
			
		end

		# if current flows from A towards B to E to G
		b3= []
		b3 << a[0] 
		b3 << a[3]
		b3 << a[8]
		dc = b3.flatten
		dc1 = dc.select{|x| x.class == Fixnum}
		d3 = 0
		for i in 0..(dc1.length-1) 
			d3 += dc1[i]
			
		end

		# if current flows from A towards D to C to E to G
		b4 = []
		b4 << a[1] 
		b4 << a[4]
		b4 << a[5]
		b4 << a[8]
		ec = b4.flatten
		ec1 = ec.select{|x| x.class == Fixnum}
		d4 = 0
		for i in 0..(ec1.length-1) 
			d4 += ec1[i]
			
		end

		# if current flows from A towards D to C to B to E to G
		b5 = []
		b5 << a[1] 
		b5 << a[4]
		b5 << a[2]
		b5 << a[3]
		b5 << a[8]
		fc = b5.flatten
		fc1 = fc.select{|x| x.class == Fixnum}
		d5 = 0
		for i in 0..(fc1.length-1) 
			d5 += fc1[i]
		end
	
		# if current flows from A towards D to C to F to G
		b6 = []
		b6 << a[1] 
		b6 << a[4]
		b6 << a[6]
		b6 << a[9]
		gc = b6.flatten
		gc1 = gc.select{|x| x.class == Fixnum}
		d6 = 0
		for i in 0..(gc1.length-1) 
			d6 += gc1[i]
		end

	   # if current flows from A towards D to F to G
		b7 = []
		b7 << a[0] 
		b7 << a[7]
		b7 << a[9]
		hc = b7.flatten
		hc1 = hc.select{|x| x.class == Fixnum}
		d7 = 0
		for i in 0..(hc1.length-1) 
			d7 += hc1[i]
		end


		c = []
		c << d
		c << d1
		c << d2
		c << d3
		c << d4
		c << d5
		c << d6
		c << d7	
        for i in 0..(c.length-1)
			if c.min == c[i]
				sol = eval("b"+"#{i}").length
				for n in 0..(sol-1)
					a.delete_if{|o| o == eval("b"+"#{i}")[n]}
				end
			end			
		end
		#puts a
    a    
	end
end

# edited the following for auto_check by ashbb

$test0 =<<EOS
@data = [
  ['A','B',50],
  ['A','D',150],
  ['B','C',250],
  ['D','C',50],
  ['B','E',250],
  ['D','F',400],
  ['C','F',100],
  ['C','E',350],
  ['F','G',100],
  ['E','G',200]
]
EOS

$test1 =<<EOS
@data = [
   [ 'A', 'B', 50],
   [ 'A', 'D', 150],
   [ 'B', 'C', 250],
   [ 'B', 'E', 250],
   [ 'C', 'E', 350],
   [ 'C', 'D', 50],
   [ 'C', 'F', 100],
   [ 'E', 'H', 200],
   [ 'F', 'H', 100],
   [ 'D', 'G', 350],
   [ 'G', 'F', 50],
   [ 'C', 'G', 30]
]
EOS

$test2 =<<EOS
@data = [
   [ 'A', 'B', 10],
   [ 'A', 'C', 100],
   [ 'A', 'D', 100],
   [ 'B', 'C', 10],
   [ 'B', 'D', 100],
   [ 'C', 'D', 10]
]
EOS

$test3 =<<EOS
@data = [
   [ 'A', 'B', 10],
   [ 'A', 'C', 100],
   [ 'A', 'D', 100],
   [ 'B', 'C', 10],
   [ 'B', 'D', 100],
   [ 'C', 'D', 10],
   [ 'B', 'E', 10],
   [ 'C', 'F', 10],
   [ 'D', 'G', 10]
]
EOS
    
def bridge_method test
  eval test
  r = Resistor.new
  r.reductant_resistors(@data).collect{|a, b,| a + b}
end

