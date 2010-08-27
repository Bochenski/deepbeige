class Node
  attr_reader :forward_nodes, :output_value
  attr_accessor :input_value, :deviation
  def initialize
    @forward_nodes = {}
    @weights =[]
    @input_value = 0
    @deviation = rand
  end
  #take our input value, pass it through our sigmoid function (tanh)
  #and then pass on our output value to each of our forward nodes
  def evaluate
    @output_value = Math.tanh(@input_value)
    #p "output value #{@output_value}"
    @forward_nodes.each do |node, weight|
      #p "weight #{weight} old input #{node.input_value}"
      node.input_value += @output_value * weight
      #p "new input #{node.input_value}"
    end
    @input_value = 0
  end
  
  def attach_forward_node node, sequence
    if @weights.count <= sequence
      @weights << rand
    end
    
    @forward_nodes[node] = @weights[sequence]
  end
  
  def detatch_all_forward_nodes
    @forward_nodes = {}
  end
  
  def mutate
    print "old weights: #{@weights.values}"
    @weights.each do |weight|
      weight = gaussian_random * @deviation + weight   # new_random_number = gaussian_rand * standard_deviation + average
    end
    print "new weights: #{@weights.values}"
    
    i = 0
    @forward_values.each do |key,value|
      @forward_values[key] = @weights[i]
      i += 1
    end
    
    #and now mutate the deviation
    @deviation = gaussian_random * @deviation + @deviation
  end
  
  def breed
  end
  
  def clone
    clone = self.new
    
    clone.deviation = self.deviation
    self.weights.each do |weight|
      clone.weights << weight
    end
    
    #being pure we clone the forward node refs as well
    #although in practice these are about to be updated with new nodes
    self.forward_nodes.each do |key,value| 
      clone[key] = value
    end
    
    clone
  end
  
private  
  def gaussian_random
     u1 = u2 = w = g1 = g2 = 0  # declare
     begin
       u1 = 2 * rand - 1
       u2 = 2 * rand - 1
       w = u1 * u1 + u2 * u2
     end while w >= 1
      
     w = Math::sqrt( ( -2 * Math::log(w)) / w )
     g2 = u1 * w;
     g1 = u2 * w;
     # g1 is returned  
  end
end