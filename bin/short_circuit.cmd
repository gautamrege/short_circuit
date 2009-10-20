#!/usr/bin/ruby

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'short_circuit'))

circuit = 
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


run = ShortCircuit.new(circuit, 'A', 'G') 
run.get_shortest_path [], 'A', 0
run.get_redundant_resistors

puts "Shortest Path: #{run.shortest_path}"
puts "Lowest resistance: #{run.lowest_load}"
puts "Redundant Resistors: "
run.redundant_resistors.each {|i| puts "Resistance #{i[2]} ohm between #{i[0]} and #{i[1]}" }


