class Node
  attr_reader :forward_nodes, :output_value
  attr_accessor :input_value
  def initialize
    @scale = 1 #TODO: need to have randomly generated scales
    @forward_nodes = {}
    @input_value = 0
  end
  #take our input value, pass it through our sigmoid function 
  #and then pass on our output value to each of our forward nodes
  def evaluate
    @output_value = 1/(1+Math.exp(-(@scale * @input_value)))
    @forward_nodes.each do |node, weight|
      node.input_value += @output_value * weight
    end
    @input_value = 0
  end
  
  def attach_forward_node node, weight
    @forward_nodes[node] = weight
  end
end