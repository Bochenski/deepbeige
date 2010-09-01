class NeuralNet
  attr_accessor :input
  attr_reader :network              

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
  
  def fingerprint
    topline = ""
    fingerprint = ""
    @network.each do |tier|
      topline << "#{tier.count},"
      tier.each do |node| 
        fingerprint << node.fingerprint
      end
    end  
    topline.chop + "\n" + fingerprint
  end
  
  def reload fingerprint
    #fingerprint contains an array of strings
    i = 0
    tiers = fingerprint[i].split(',').to_a
    i += 1
        
    @network = []
    tiers.each do |tier|
      nodes = []
      tier.to_i.times do
        node_fingerprint = fingerprint[i]
        i += 1
        node = Node.new
        node.reload node_fingerprint
        nodes << node
      end
      @network << nodes
    end
  
    link_tiers
    true
  end

  #Nets can make small changes (mutations) to themselves
  def mutate
    #for the time being we won't take on
    #the ability to mutate the number of
    #nodes and their configuration
    #focussing instead on simple node weight mutation
    @network.each do |tier|
      tier.each do |node|
        node.mutate
      end
    end
    self
  end
  
  def clone
    clone = NeuralNet.new 0,0,0
    #iterate in through each tier
    @network.each do |tier|
      nodes = []
      tier.each do |node|
        cloned_node = node.clone
        cloned_node.detatch_all_forward_nodes
        nodes << cloned_node
      end
      clone.network << nodes
    end
    #now relink the network
    clone.link_tiers
    #and send back our clone
    clone
  end
  
protected  
  #Nets can procreate with other nets and produce a new net
  def procreate (dad)
  end
  
private
  def generate_nodes inputs, outputs, tiers
    input_nodes = []
    inputs.times do 
      input_nodes << Node.new
    end
    if input_nodes.count > 0
      @network << input_nodes
    end
    (tiers - 2).times do
      tier = []
      10.times do
        tier << Node.new  
      end
      @network << tier
    end
    
    output_nodes = []
    outputs.times do
      output_nodes << Node.new
    end
    if output_nodes.count >0
      @network << output_nodes
    end
  end
  
protected
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