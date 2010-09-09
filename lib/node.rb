class Node
  attr_reader :forward_nodes, :output_value
  attr_accessor :input_value, :sigma, :weights, :bias
  def initialize sigma
    @input_value = 0
    @forward_nodes = {}
    @weights =[]
    @bias = 0
    @sigma = sigma
  end
  #take our input value (sum of weighted outputs of backward connected nodes)
  #, subtract the bias and pass the result through our sigmoid function (tanh)
  # finally then pass on our output value to each of our forward nodes
  def evaluate
    @output_value = Math.tanh(@input_value - @bias)
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
      @weights << ((rand * 0.4 ) - 0.2) #sampled from a uniform distribution in range ± 0.2
    end
    
    @forward_nodes[node] = @weights[sequence]
  end
  
  def detatch_all_forward_nodes
    @forward_nodes = {}
  end
  
  def mutate
    new_weights = []
    @weights.each do |weight|
      new_weights << weight + @sigma * gaussian_random # new_random_number = average + standard_deviation  * gaussian_rand
    end
    @weights = new_weights
    if @forward_values
      i = 0
      @forward_values.each do |key,value|
        @forward_values[key] = @weights[i]
        i += 1
      end
    end
    
    #mutate the bias
    @bias = @bias + gaussian_random * @sigma

    self
  end
    
  def clone
    clone = Node.new(self.sigma)
    
    clone.sigma = self.sigma
    clone.bias = self.bias
    
    @weights.each do |weight|
      clone.weights << weight
    end
    
    #being pure we clone the forward node refs as well
    #although in practice these are about to be updated with new nodes
    self.forward_nodes.each do |key,value| 
      clone.forward_nodes[key] = value
    end
    
    clone
  end
  
  def fingerprint
    fingerprint = "#{@sigma.to_s}:#{@bias.to_s}:"
    @weights.each do |weight|
      fingerprint += "#{weight.to_s},"
    end
    fingerprint = fingerprint.chop + "\n"
  end
  
  def reload fingerprint
    self.detatch_all_forward_nodes
    @weights = []
    self.sigma = fingerprint.split(':')[0].to_f
    self.bias = fingerprint.split(':')[1].to_f
    if fingerprint.split(":").count == 3
      fingerprint.split(":")[2].split(',').each do |weight|
        @weights << weight.to_f
      end
    end
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