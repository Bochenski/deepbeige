class Node
  attr_reader :forward_nodes, :output_value
  attr_accessor :input_value
  def initialize
    @scale = (rand * 1.5) + 0.5
    @forward_nodes = {}
    @input_value = 0
  end
  #take our input value, pass it through our sigmoid function 
  #and then pass on our output value to each of our forward nodes
  def evaluate
    #p "evaluating #{self} scale #{@scale} input #{@input_value}"
    @output_value = 1/(1+Math.exp(-(@scale * @input_value)))
    #p "output value #{@output_value}"
    @forward_nodes.each do |node, weight|
      #p "weight #{weight} old input #{node.input_value}"
      node.input_value += @output_value * weight
      #p "new input #{node.input_value}"
    end
    @input_value = 0
  end
  
  def attach_forward_node node, weight
    @forward_nodes[node] = weight
  end
end