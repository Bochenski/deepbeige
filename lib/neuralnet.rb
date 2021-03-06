require 'rubygems'
require 'node'

class NeuralNet
  attr_accessor :input, :id   
  attr_reader :network       
  @@next_id = 0
  
  def self.get_id
    @@next_id +=1
  end

  def initialize
    @id = NeuralNet.get_id
    @network = []
    @sigma = 0.05
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
  
  def generate options
    inputs = 1
    if options[:inputs]
      inputs = options[:inputs]
    end
    outputs = 1
    if options[:outputs]
      outputs = options[:outputs]
    end
    tiers = 2
    if options[:tiers]
      tiers = options[:tiers]
    end
    @width = 0
    if options[:width]
      @width = options[:width]
    end
    @height = 0
    if options [:height]
      @height = options[:height]
    end

    @network = []
    input_nodes = []
    inputs.times do 
      input_nodes << Node.new(@sigma)
    end
    if input_nodes.count > 0
      @network << input_nodes
    end
    if height > 1 && width > 1

      if width == height
        #ok, slightly impure but this is our clue
        #that we're dealing with a 2D board and we're going 
        #to insert a special layer to reflect the board topology
        tiers = tiers -1
        tier = []
        n = 2
        i = 0
        j = 0
        (height - n).times do
          (width - n).times do
            node = Node.new(@sigma)
          end    
          n  = n + 1
          i += 1
        end
        @network << tier
      else
        #for now we will not bother with rectangles 
      end
     
    end
    (tiers - 2).times do
      tier = []
      10.times do
        tier << Node.new(@sigma)
      end
      @network << tier
    end
    
    output_nodes = []
    outputs.times do
      output_nodes << Node.new(@sigma)
    end
    if output_nodes.count >0
      @network << output_nodes
    end
    link_tiers
    recalculate_tau
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
    topline.chop + "\n" + @sigma.to_s + "\n" + @tau.to_s + "\n" + @width.to_s + "\n" + @height.to_s + "\n"+ fingerprint
  end
  
  def reload fingerprint
    #fingerprint contains an array of strings
    i = 0
    tiers = fingerprint[i].split(',').to_a
    i += 1
    @sigma = fingerprint[i].to_f
    i += 1
    @tau = fingerprint[i].to_f
    i += 1
    @width = fingerprint[i].to_i
    i += 1
    @height = fingerprint[i].to_i
    i += 1
        
    @network = []
    tiers.each do |tier|
      nodes = []
      tier.to_i.times do
        node_fingerprint = fingerprint[i]
        i += 1
        node = Node.new(@sigma)
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
    
    #first we mutate sigma
    @sigma = @sigma * Math.exp(@tau * gaussian_random)
    @network.each do |tier|
      tier.each do |node|
        node.sigma = @sigma
        node.mutate
      end
    end
    self
  end
  
  def clone
    clone = NeuralNet.new
    clone.sigma = self.sigma
    clone.tau = self.tau
    clone.width = self.width
    clone.height = self.height
    
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
  
  def save_to_file file
    File.open(file, 'w')  do |f|
       f.write(self.fingerprint) 
    end
  end
  
  def load_from_file file
    fingerprint = []
    File.open(file, 'r') do |f|
      while line = f.gets do
        fingerprint << line
      end
    end
    reload fingerprint
  end
  
protected
  attr_accessor :sigma, :tau, :width, :height
  
  def link_tiers
    #first cut lets link every node on a tier to each node on the subsequent tier
    i = 1
    @network.each do |tier|
      if i == 1 && @width > 1 && @height > 1
        
      end
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
  
private
  #This is a constant related to the size of our network
  #and the number of connections it contains
  def recalculate_tau
    number_of_variables = 0
    @network.each do |tier|
      tier.each do |node|
        number_of_variables += 1 + node.weights.count
      end
    end
    @tau = 1 / (Math.sqrt(2 * Math.sqrt(number_of_variables)))
  end
  
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