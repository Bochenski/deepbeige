require_relative 'Node'

class NeuralNet
  attr_accessor :input

  def initialize inputs, outputs, tiers
    @network = []
    generate_nodes inputs, outputs, tiers
    link_tiers
  end
    
  def evaluate 
    #we expect to find one input value in input for each of our input nodes
    input_nodes = @network.first
    
    i = 0
    input_nodes.each do |node|
      node.input_value = @input[i]
      i += 1
    end
    
    @network.each do |tier|
      tier.each do |node|
        node.evaluate
      end
    end
    
    self.output
  end  
  
  def output
    @network.last
  end
  
  def output_value
    value = 0
    self.output.each do |node|
      value += node.output_value
    end
    value
  end
  
protected  
  #Nets can procreate with other nets and produce a new net
  def procreate (dad)
  end
  
  #Nets can make small changes (mutations) to themselves
  def mutate
  end
  
  def clone
    #iterate in reverse through each tier
    
  end

private
  def generate_nodes inputs, outputs, tiers
    input_nodes = []
    inputs.times do 
      input_nodes << Node.new
    end
    
    @network << input_nodes
  
    (tiers - 2).times do
      tier = []
      9.times do
        tier << Node.new  
      end
      @network << tier
    end
    
    output_nodes = []
    outputs.times do
      output_nodes << Node.new
    end
    @network << output_nodes
  end
  
  def link_tiers
    #first cut lets link every node on a tier to each node on the subsequent tier
    i = 1
    @network.each do |tier|
      if i < @network.count
        tier.each do |node|
          j = 0
          @network[i].each do |next_node|
            node.attach_forward_node next_node, j
            j += 1
          end
        end
      end
      i +=1
    end
  end
end