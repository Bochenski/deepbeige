class Node
  
  #take our input value, pass it through our noise function 
  #and then pass on our output value to each of our forward nodes
  def evaluate input
    output = input
    @forwardnodes.each do |node|
      node.evaluate output
    end
  end
end