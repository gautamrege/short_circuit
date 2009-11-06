#!/usr/bin/env ruby

class ResistorLink
 
  def initialize(link1,link2,rs)
    # takes in the two endpoints and the
    # resistor value that connects the two points
    @linkends = Array.new
    @linkends.push(link1)
    @linkends.push(link2)
    @resistorvalue = rs
    @used = 0
  end

  def printInfo()
    # Prints to the screen the two points
    # that this object is connected to and
    # the value of the resistor connecting the
    # points
    info = nil
    @linkends.each do |linkend|
      info = "#{info} " << "#{linkend}"
    end
    info = "#{info} " << "#{@resistorvalue}"
    puts "#{info}"
  end

  def getOtherEnd(searchvalue)
    # takes in a point on the circuit
    # and if that point matches one of the points
    # in this object it returns the other point
    # that it is connected to.  If the first
    # point is not a part of this object then
    # a -1 is returned to indicate this object does
    # not connect to the searched point
    otherend = 0
    foundit = 0
    @linkends.each do |linkend|
      if linkend.eql? searchvalue
        foundit = 1
      else
        otherend = linkend 
      end
    end
    if foundit == 0
      otherend = -1
    end
    otherend
  end 

  def getResistor
    @resistorvalue
  end

  def setUsed(flag)
    @used = flag
  end
  
  def getUsed
    @used
  end

  def matchEnds(ends)
    # takes in two points from the circuit
    # and if those points match the points
    # of this object it returns a 1 otherwise
    # it returns a 0
    isMatch = 0
    end1 = ends[0,1]
    end2 = ends[1,2]
    if (@linkends[0].eql? end1) || (@linkends[1].eql? end1)
      if (@linkends[0].eql? end2) || (@linkends[1].eql? end2)
        isMatch = 1
      end
    end
    isMatch
  end

end
 
if __FILE__ == $0
  @allPathsTaken = 0
  @resistorsum = Array.new()
  @linkarray = Array.new()
  @startposition = 'A'
  @endposition = 'G'
  @pathtaken = Array.new()
  @pathtaken.push(@startposition) 
  @completePaths = Array.new() 
  @completeResistance = Array.new()
  @deadendlist = Array.new()
  @lasthop = nil

  @linkarray[0]=ResistorLink.new('A','B',50)
  @linkarray[1]=ResistorLink.new('A','D',150)
  @linkarray[2]=ResistorLink.new('B','C',250)
  @linkarray[3]=ResistorLink.new('B','E',250)
  @linkarray[4]=ResistorLink.new('C','E',350)
  @linkarray[5]=ResistorLink.new('C','D',50)
  @linkarray[6]=ResistorLink.new('C','F',100)
  @linkarray[7]=ResistorLink.new('D','F',400)
  @linkarray[8]=ResistorLink.new('E','G',200)
  @linkarray[9]=ResistorLink.new('F','G',100)

  def findUnneededResistors(path)
    # uses the path of least resistance
    # to find the ResistorLink objects
    # that make up that path.  If the
    # object was a part of the least resistant
    # path mark it as Used.  Then when completed
    # create a list of unused ResistorLink objects
    # and have them print their values
    puts "Unneeded Resistor List:"
    numofchars = path.length
    count = 0
    while count < (numofchars-1) do
      hop = path[count,2]
      count = count + 1
      @linkarray.each do |link|
        if link.matchEnds(hop) == 1
          link.setUsed(1)
        end
      end
    end
    @linkarray.each do |link|
      if link.getUsed() == 0
        link.printInfo()
      end
    end
  end

  def beenThereDoneThat(searchvalue)
    # this is to keep from crossing the
    # same point twice in one route
    beenThere = 0
    @pathtaken.each do |taken|
      if taken.eql? searchvalue
        beenThere = 1
      end
    end
    beenThere
  end

  def storeValues()
    # when a start to finish route is found
    # this stores the route and resistance
    # total away so when we have exhausted
    # all paths we can easily check the start to
    # finish paths along with total resistance of the path
    tempsum = 0
    temppath = nil
    @pathtaken.each do |hop|
      temppath = "#{temppath}" << "#{hop}"
    end  
    @completePaths.push(temppath)
    @resistorsum.each do |rvalue|
      tempsum = tempsum + rvalue
    end  
    @completeResistance.push(tempsum)
  end

  def popOff()
    # used to move back when we have either
    # reached the finish or a deadend
    @lasthop = @pathtaken.pop() 
    #puts "Setting #{@lasthop} to lasthop"
    poppedvalue = @resistorsum.pop()
    if @lasthop == nil
      @allPathsTaken = 1
    end 
    #puts "Moving Back to #{@pathtaken.last}"
    #puts "Removing #{poppedvalue} from Sum"
  end

  def printPath()
    # Prints the route taken for a successful
    # start to finish route.  Also sums the 
    # resistors to give us total resistance
    # Both will be used to check for path of
    # least resistance when all paths are exhausted
    hoplist = nil
    sum = 0
    @pathtaken.each do |hop|
      hoplist = "#{hoplist}" << "#{hop}"
    end
    @resistorsum.each do |rvalue|
      sum = sum + rvalue
    end
    puts "Successful Path Found: #{hoplist} Resistance was: #{sum}"
  end

  def addToDeadend(deadendpath)
    # if a route is deadended it has been
    # found to not have any other working paths
    # that branch off from it.  This is used
    # to stop us from going down a route a second
    # time for a given path
    hoplist = nil
    deadendpath.each do |hop|
      hoplist = "#{hoplist}" << "#{hop}"
    end
    @deadendlist.push(hoplist)
    #puts "Added Deadend Path: #{hoplist}"
  end

  def isDeadend(path,nexthop)
    # compares the route we are looking to take
    # to the deadend list to save us a redundant
    # trip
    isDeadend = 0
    hoplist = nil
    path.each do |hop|
      hoplist = "#{hoplist}" << "#{hop}"
    end
    hoplist = "#{hoplist}" << "#{nexthop}"
    @deadendlist.each do |deadend|
      if deadend.eql? hoplist
        isDeadend = 1
        #puts "Path: #{hoplist} is a Deadend!"
      end
    end
    isDeadend
  end

  def printCurrentRoute(path)
    # prints the route that is currently
    # being traveled.  Used mainly for
    # debugging
    hoplist = nil
    path.each do |hop|
      hoplist = "#{hoplist}" << "#{hop}"
    end
    #puts "CurrentPath: #{hoplist}"
  end

  def findLeastResistance()
    # goes through list of all complete
    # start point to end point paths to
    # find the path of least resistance
    loopcount = 0
    tempsum = nil
    tempindex = nil
    leastpath = nil
    @completeResistance.each do |totalr|
      if tempsum == nil      
        tempsum = totalr
      end
      if (totalr < tempsum)
        tempsum = totalr
        tempindex = loopcount
      end
      loopcount = loopcount + 1
    end
    leastpath = @completePaths[8]
    puts "Path of Least Resistance: #{leastpath} Resistance: #{tempsum}"
    leastpath
  end
 
  def findRoute(searchvalue)
    # uses a start point to find connections
    # to other points.  Searches through the array
    # of ResistorLink objects to find possible next hops
    if @allPathsTaken == 1
      leastresistance = findLeastResistance()
      findUnneededResistors(leastresistance)
    else
      #puts "Searching for #{searchvalue}"
      foundUntraveledLink = 0
      if searchvalue.eql? @endposition
      else
      @linkarray.each do |linko|
        otherEnd = linko.getOtherEnd(searchvalue)
        if otherEnd == -1
        else
          #puts "Otherend is: #{otherEnd}"
          # don't go to points we have already been to
          if (beenThereDoneThat(otherEnd) == 0)
            # want to avoid bouncing between two points
            if (otherEnd != @lasthop)
              if (isDeadend(@pathtaken,otherEnd) == 0)
                foundUntraveledLink = 1
                @lasthop = nil
                #puts "Adding #{linko.getResistor()} to Sum"
                @resistorsum.push(linko.getResistor())
                @pathtaken.push(otherEnd)
                #puts "Traveling to #{@pathtaken.last}"
                printCurrentRoute(@pathtaken)
                if otherEnd.eql? @endposition
                  #puts "Found the End!"
                  storeValues()
                  printPath()
	        #  popOff()
	        end
                findRoute(@pathtaken.last)
                break
              end
            end
          end
        end
      end # end position search if
      end
      if foundUntraveledLink == 0
        #puts "Didn't find an untraveled link"
        addToDeadend(@pathtaken)
        popOff()
        findRoute(@pathtaken.last)
      end
    end
  end

  # start us off by searching for
  # points connected to the starting point
  findRoute(@startposition)

end
